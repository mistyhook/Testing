import SwiftUI
import CoreLocation
import HealthKit
import UIKit
import SwiftData

class LocationManagerDelegate: NSObject, CLLocationManagerDelegate {
    var onLocationUpdate: ((CLLocation) -> Void)?
    var previousLocation: CLLocation?
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        onLocationUpdate?(location)
    }
}

struct ContentView: View {
    @State private var isRunning = false
    @State private var distance = Measurement(value: 0, unit: UnitLength.meters)
    @State private var totalTime = 0
    @State private var routeCoordinates: [CLLocationCoordinate2D] = []
    @State private var timer: Timer?
    @State private var currentIntervalIndex = 0
    @State private var currentSet = 1
    @State private var showWorkoutSummary = false
    @State private var timeRemaining = 0
    @State private var heartRate: Double?
    @State private var heartRateQuery: HKQuery?
    @State private var averagePace: Double = 0.0

    private let locationManager = CLLocationManager()
    private let locationManagerDelegate = LocationManagerDelegate()
    private let healthStore = HKHealthStore()
    private let timerInterval = 1
    
    let intervals: [Interval] = [
        Interval(name: "Sprinting", duration: 30, effort: 0.9, sets: 3),
        Interval(name: "Jogging", duration: 90, effort: 0.5, sets: 3)
    ]
    
    var body: some View {
        NavigationView {
            ZStack {
                if isRunning {
                    ScrollView {
                        runningDetailView
                    }
                } else {
                    initialView
                }
            }
            .onAppear {
                setupLocationManager()
                requestAuthorizationForHealthKit()
            }
            .alert(isPresented: $showWorkoutSummary) {
                Alert(
                    title: Text("Workout Summary"),
                    message: Text("Average Pace: \(formattedPace) m/s"),
                    dismissButton: .default(Text("OK")) {
                        resetWorkout()
                    }
                )
            }
        }
    }
    
    private var initialView: some View {
        ZStack {
            Image("backgroundfinal")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
                .ignoresSafeArea()
            
            VStack {
                startButton
                viewPastRunsButton
            }
            .padding()
        }
    }
    
    private var runningDetailView: some View {
        ZStack {
            VStack(spacing: 14) {
                Text(currentIntervalText)
                    .font(.system(size: 18)) 
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.bottom, 10)
                
                VStack(spacing: -4) {
                    Text("\(timeRemaining)")
                        .font(.system(size: 46))
                        .fontWeight(.black)
                        .foregroundColor(Color(red: 0.83, green: 0.20, blue: 0.20))
                    Text("seconds")
                        .font(.system(size: 11.31))
                        .fontWeight(.black)
                        .foregroundColor(.white)
                }
                HStack(alignment: .top, spacing: 40) {
                    VStack(spacing: 0) {
                        Text("\(Int(heartRate ?? 0))")
                            .fontWeight(.black)
                            .font(.system(size: 30.6))
                            .foregroundColor(.white)
                        HStack(spacing:0){
                            Image(systemName: "heart.fill")
                                .foregroundColor(Color(red: 0.83, green: 0.20, blue: 0.20))
                            Text("BPM")
                                .font(.system(size: 11))
                                .fontWeight(.medium)
                                .foregroundColor(Color(red: 0.83, green: 0.20, blue: 0.20))
                        }
                    }
                    VStack(spacing: 0) {
                        Text("\(formattedDistance)")
                            .font(.system(size: 30.6))
                            .fontWeight(.black)
                            .foregroundColor(.white)
                        Text("METERS")
                            .font(.system(size: 11))
                            .fontWeight(.medium)
                            .foregroundColor(Color(red: 0.83, green: 0.20, blue: 0.20))
                    }
                }
                HStack(spacing: 0) {
                    Button(action: stopWorkout) {
                        Text("STOP")
                            .font(.system(size: 18))
                            .fontWeight(.black)
                            .foregroundColor(Color(red: 0.07, green: 0.07, blue: 0.07))
                            .padding(EdgeInsets(top: 2, leading: 22, bottom: 3, trailing: 23))
                            .background(Color(red: 0.83, green: 0.20, blue: 0.20))
                            .cornerRadius(9)
                    }
                }
            }
            .offset(x: 0, y: 16.50)
        }
        .frame(width: 176, height: 215)
        .background(Color(red: 0.07, green: 0.07, blue: 0.07))
    }
    
    private var startButton: some View {
        Button(action: startWorkout) {
            ZStack {
                Rectangle()
                    .foregroundColor(.red)
                    .frame(width: 122, height: 73)
                    .cornerRadius(10)
                VStack{
                    Text("Start")
                        .font(.system(size: 19))
                        .fontWeight(.black)
                        .foregroundColor(.white)
                    Text("Sprint")
                        .font(.system(size: 19))
                        .fontWeight(.black)
                        .foregroundColor(.white)
                }
            }
        }
    }
    
    private var viewPastRunsButton: some View {
        NavigationLink(destination: PastRunsView()) {
            Text("View Past Runs")
                .font(.system(size: 12))
                .fontWeight(.regular)
                .foregroundColor(.white)
                .padding()
                .background(Color.gray)
                .cornerRadius(10)
        }
    }
    
    private func setupLocationManager() {
        locationManager.delegate = locationManagerDelegate
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        locationManagerDelegate.onLocationUpdate = { location in
            handleLocationUpdate(location)
        }
    }
    
    private func handleLocationUpdate(_ location: CLLocation) {
        if isRunning {
            let distanceDelta = location.distance(from: locationManagerDelegate.previousLocation ?? location)
            distance = distance + Measurement(value: distanceDelta, unit: UnitLength.meters)
            locationManagerDelegate.previousLocation = location
            routeCoordinates.append(location.coordinate)
        }
    }
    
    private func startWorkout() {
        isRunning = true
        distance = Measurement(value: 0, unit: UnitLength.meters) // Reset distance
        totalTime = 0
        currentIntervalIndex = 0
        currentSet = 1
        timeRemaining = intervals[currentIntervalIndex].duration
        startInterval()
        startHeartRateUpdates()
        updateTimer()
    }
    
    private func stopWorkout() {
        isRunning = false
        timer?.invalidate()
        stopHeartRateUpdates()
        calculateAveragePace()
        saveRunData()
        showWorkoutSummary = true
    }
    
    private func resetWorkout() {
        distance = Measurement(value: 0, unit: UnitLength.meters)
        totalTime = 0
        currentIntervalIndex = 0
        currentSet = 1
        isRunning = false
    }
    
    private func startInterval() {
        let interval = intervals[currentIntervalIndex]
        timeRemaining = interval.duration
    }
    
    private func updateTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: TimeInterval(timerInterval), repeats: true) { _ in
            if self.timeRemaining > 0 {
                self.timeRemaining -= self.timerInterval
                self.totalTime += self.timerInterval
            } else {
                self.currentSet += 1
                if self.currentSet > self.totalSets {
                    self.currentSet = 1
                }
                self.currentIntervalIndex = (self.currentIntervalIndex + 1) % self.intervals.count
                self.startInterval()
            }
        }
    }
    
    private var totalSets: Int {
        intervals.reduce(0) { $0 + $1.sets }
    }
    
    private var currentIntervalText: String {
        let interval = intervals[currentIntervalIndex]
        return "\(interval.name) \(currentSet)/\(totalSets)"
    }
    
    private var formattedDistance: String {
        String(format: "%.2f", distance.value)
    }
    
    private var formattedPace: String {
        String(format: "%.2f", averagePace)
    }
    
    private func calculateAveragePace() {
        averagePace = totalTime > 0 ? distance.value / Double(totalTime) : 0
    }
    
    private func saveRunData() {
        let runData = RunData(date: Date(), averagePace: averagePace)
        UserDefaults.standard.saveRunData(runData)
    }
    
    private func requestAuthorizationForHealthKit() {
        let readTypes: Set = [HKObjectType.quantityType(forIdentifier: .heartRate)!]
        healthStore.requestAuthorization(toShare: nil, read: readTypes) { success, error in
            if !success {
                print("Authorization failed")
            }
        }
    }
    
    private func startHeartRateUpdates() {
        let heartRateType = HKObjectType.quantityType(forIdentifier: .heartRate)!
        let query = HKObserverQuery(sampleType: heartRateType, predicate: nil) { query, completionHandler, error in
            if error != nil {
                return
            }
            self.fetchHeartRateData()
            completionHandler()
        }
        heartRateQuery = query
        healthStore.execute(query)
    }
    
    private func stopHeartRateUpdates() {
        if let query = heartRateQuery {
            healthStore.stop(query)
        }
    }
    
    private func fetchHeartRateData() {
        let heartRateType = HKObjectType.quantityType(forIdentifier: .heartRate)!
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)
        let query = HKSampleQuery(sampleType: heartRateType, predicate: nil, limit: 1, sortDescriptors: [sortDescriptor]) { query, results, error in
            guard let results = results as? [HKQuantitySample], let sample = results.first else { return }
            DispatchQueue.main.async {
                self.heartRate = sample.quantity.doubleValue(for: HKUnit(from: "count/min"))
            }
        }
        healthStore.execute(query)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct Interval {
    let name: String
    let duration: Int
    let effort: Double
    let sets: Int
}

struct RunData: Codable {
    let date: Date
    let averagePace: Double
}

extension RunData: Identifiable {
    var id: Date { date }
}

struct PastRunsView: View {
    @State private var pastRuns: [RunData] = []

    var body: some View {
        List(pastRuns) { run in
            VStack(alignment: .leading) {
                Text("Date: \(run.date, formatter: dateFormatter)")
                Text("Average Pace: \(String(format: "%.2f", run.averagePace)) m/s")
            }
        }
        .onAppear(perform: loadPastRuns)
        .navigationTitle("Past Runs")
    }

    private func loadPastRuns() {
        pastRuns = UserDefaults.standard.loadRunData()
    }

    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }
}

extension UserDefaults {
    private enum Keys {
        static let pastRuns = "pastRuns"
    }

    func saveRunData(_ runData: RunData) {
        var runs = loadRunData()
        runs.append(runData)
        if let data = try? JSONEncoder().encode(runs) {
            set(data, forKey: Keys.pastRuns)
        }
    }

    func loadRunData() -> [RunData] {
        guard let data = data(forKey: Keys.pastRuns),
              let runs = try? JSONDecoder().decode([RunData].self, from: data) else {
            return []
        }
        return runs
    }
}
