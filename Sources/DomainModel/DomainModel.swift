struct DomainModel {
    var text = "Hello, World!"
        // Leave this here; this value is also tested in the tests,
        // and serves to make sure that everything is working correctly
        // in the testing harness and framework.
}

////////////////////////////////////
// Money
//
public struct Money {
    var amount : Int
    var currency : String
    
    func convert(_ curr: String) -> Money {
        if curr == currency {
            return Money(amount: amount, currency: currency)
        }
        switch currency {
        case "USD":
            switch curr {
            case "GBP":
                return Money(amount: amount / 2, currency: "GBP")
            case "EUR":
                return Money(amount: Int(Double(amount) * 1.5), currency: "EUR")
            case "CAN":
                return Money(amount: Int(Double(amount) * 1.25), currency: "CAN")
            default:
                print("Unknown currency")
            }
        case "GBP":
            switch curr {
            case "USD":
                return Money(amount: amount * 2, currency: "USD")
            case "EUR":
                return Money(amount: amount * 3, currency: "EUR")
            case "CAN":
                return Money(amount: Int(Double(amount) * 2.5), currency: "CAN")
            default:
                print("Unknown currency")
            }
        case "EUR":
            switch curr {
            case "USD":
                return Money(amount: (amount / 3) * 2, currency: "USD")
            case "GBP":
                return Money(amount: amount / 3, currency: "GBP")
            case "CAN":
                return Money(amount: Int(Double(amount * 3) / 2.5), currency: "CAN")
            default:
                print("Unknown currency")
            }
        case "CAN":
            switch curr {
            case "USD":
                return Money(amount: (amount / 5) * 4, currency: "USD")
            case "GBP":
                return Money(amount: (amount / 5) * 2, currency: "GBP")
            case "EUR":
                return Money(amount: (amount / 5) * 6, currency: "EUR")
            default:
                print("Unknown currency")
            }
        default:
            print("Unknown currency")
        }
        return Money(amount: -1, currency: "Unknown")
    }
    
    func add(_ money: Money) -> Money {
        if money.currency != currency {
            return Money(amount: self.convert(money.currency).amount + money.amount, currency: money.currency)
        } else {
            return Money(amount: amount + money.amount, currency: currency)
        }
    }
    
    func subtract(_ money: Money) -> Money {
        if money.currency != currency {
            return Money(amount: money.amount - self.convert(currency).amount, currency: money.currency)
        } else {
            return Money(amount: amount - money.amount, currency: currency)
        }
    }
}

////////////////////////////////////
// Job
//
public class Job {
    var title : String
    var type : JobType
    
    init(title: String, type: JobType) {
        self.title = title
        self.type = type
    }
    
    public enum JobType {
        case Hourly(Double)
        case Salary(UInt)
    }
    
    func calculateIncome(_ hours: Int = 2000) -> Int {
        switch self.type {
        case .Hourly(let hourly):
            return Int(Double(hourly) * Double(hours))
        case .Salary(let salary):
            return Int(salary)
        }
    }
    
    func raise(byAmount amount: Double) {
        switch self.type {
        case .Hourly(let hourly):
            self.type = .Hourly(hourly + amount)
        case .Salary(let salary):
            self.type = .Salary(UInt(Double(salary) + amount))
        }
    }
    
    public func raise(byPercent percentage: Double) {
        switch self.type {
        case .Hourly(let hourly):
            let increase = Double(hourly) * percentage
            self.type = .Hourly(hourly + increase)
        case .Salary(let salary):
            let increase = Double(salary) * percentage
            self.type = .Salary(UInt(Double(salary) + increase))
        }
    }
}

////////////////////////////////////
// Person
//
public class Person {
    var firstName: String
    var lastName: String
    var age: Int
    var job: Job? {
        didSet {
            if (age < 16) {
                print("Person is too young to have a job.")
                job = nil
            }
        }
    }
    var spouse: Person? {
        didSet {
            if (age < 18) {
                print("Person is too young to be married.")
                spouse = nil
            }
        }
    }
    
    init(firstName: String, lastName: String, age: Int) {
        self.firstName = firstName
        self.lastName = lastName
        self.age = age
    }
    
    func toString() -> String {
        let jobTitle = job?.title ?? "nil"
        let spouseName = spouse?.firstName ?? "nil"
        return "[Person: firstName:\(firstName) lastName:\(lastName) age:\(age) job:\(jobTitle) spouse:\(spouseName)]"
    }
}

////////////////////////////////////
// Family
//
public class Family {
    var members: [Person]
    
    init(spouse1: Person, spouse2: Person) {
        self.members = []
        if (spouse1.spouse == nil && spouse2.spouse == nil) {
            spouse1.spouse = spouse2
            spouse2.spouse = spouse1
            members = [spouse1, spouse2]
        }
    }
    
    func haveChild(_ child: Person) -> Bool {
        if (members.count == 2) {
            if ((members[0].age > 21 || members[1].age > 21)) {
                members.append(child)
                return true
            }
        }
        return false
    }
    
    func householdIncome() -> Int {
        var totalIncome = 0
        for member in members {
            totalIncome += member.job?.calculateIncome() ?? 0
        }
        return totalIncome
    }
}

