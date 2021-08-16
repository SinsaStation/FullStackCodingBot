import Foundation

enum UnitInfo: String, CaseIterable {
    case swift
    case kotlin
    case java
    case cPlusPlus = "C++"
    case python
    case theC = "C"
    case php
    case javaScript
    case cSharp = "C#"
    case ruby
    
    var detail: (image: String, id: Int) {
        switch self {
        case .swift:
            return ("swift", 0)
        case .kotlin:
            return ("kotlin", 1)
        case .java:
            return ("java", 2)
        case .cPlusPlus:
            return ("cpp", 3)
        case .python:
            return ("python", 4)
        case .theC:
            return ("theC", 5)
        case .php:
            return ("php", 6)
        case .javaScript:
            return ("javaScript", 7)
        case .cSharp:
            return ("cSharp", 8)
        case .ruby:
            return ("ruby", 9)
        }
    }
}

extension UnitInfo {
    enum Codes {
        static let totalElement = 5
        
        static let swift = [
            "while isGameOn() {\n\tkeepFocused()\n}",
            "if workHour >= 8 {\n\tmoney += 1000000\n} else {\n\tsleep += 10\n}",
            "for i in 0..<Int.max {\n\tmatch += 1\n\tif isTimeOver() {\n\t\t gameOver()\n\t\tbreak\n\t}\n}",
            "print(\"You are doing great!\")",
            "enum WorkLifeBalance {\n\tcase bad\n\tcase veryBad\n\tcase alreadyDead\n}"]
        
        static let kotlin = [
            "println(\"Hello, burn out!\")",
            "class FullstackMaster : Worker {\n\toverride var workHour = 24\n\toverride var name = \"Debug Kim\"\n}",
            "when (tired) {\n\ttrue -> takeFive()\n\tfalse -> keepWorking()\n}",
            "if (matchSuccess()) {\n\tprintln(\"You are doing great!\")\n}",
            "for (i in 0 until max) {\n\tscore += 777\n}"]
        
        static let java = [
            "public class Answer {\n\tpublic static void main(){\n\t\tSystem.out.println(\"Good\")\n\t}\n}",
            "public class WrongAnswer {\n\tString str = \"Wrong\"\n\n\t void print() {\n\t\tSystem.out.println(str)\n\t}\n}",
            "for (int i = 0; i < 100; i++) {\n\tif (i % 2 == 0) {\n\t\tSystem.out.println(\"Excellent\")\n\t}\n}",
            "class Faster {\n\tpublic void printState() {\n\t\tSystem.out.println(\"Very Slow\")\n\t}\n}",
            "class Score {\n\tpublic int yourScore() {\n\t\tSystem.out.println(\"Your score\")\n\t\treturn 100\n\t}\n}"]
        
        static let cPlusPlus = [
            "int main() {\n\tcout << \"Good\";\n\treturn 90;\n}",
            "void wrong() {\n\tstring temp;\n\ttemp = \"Wrong\"\n\tcount << temp;\n}",
            "int main() {\n\tstring str = \"Faster!!\";\n\n\tcout << str << endl;\n\tcout << str;\n\treturn EXIT_SUCCESS;\n}",
            "int main() {\n\tfor (int count = 0; count < 10; ++count)\n\t\tstd::cout << \"Wrong direction\"\n\treturn 0;\n}",
            "int main(void) {\n\tstring str = \"Cheer up!\";\n\tstd::cout << \"Message : \" << str;\n\n\treturn 50;\n}"]
        
        static let python = [
            "def correct_answer():\n\tans = \"Good\"\n\tprint(ans)",
            "def incorrect_answer():\n\tprint(\"Bad\")",
            "def print_excellent():\n\tnum = 0\n\twhile num <= 100:\n\t\tnum+=1\n\treturn num",
            "for _ in range(100):\n\tprint(\"Faster!!\")",
            "while False:\n\tprint(\"Focus\")"]
        
        static let theC = [
            "int main() {\n\tprintf(\"Good\");\n\treturn 100;\n}",
            "int main() {\n\tprintf(\"It would return your score\");\n\treturn 0;\n}",
            "int main() {\n\tchar grade = \'A\'\n\tprintf(\"Your grade\", grade)\n\treturn 100;\n}",
            "for(int i = 0; i < 100; i++){\n\tprintf(\"Faster, Faster!!\");\n}",
            "int main() {\n\tfor(int i = 0;; i++){\n\t\tprintf(\"Bad\");\n\t}\n\treturn 0;\n}"]
        
        static let php = [
            "echo \"Faster, Faster!\";",
            "if ( $work_hour > 10 ) {\n\techo \"Must go home\"\n};",
            "switch ( $score ) {\n\tcase 0:\n\t\techo \"Terrible\";\n\tdefault:\n\t\techo \"Alright!\";\n}",
            "include \'fiver_time.php\';\ninclude \'bonus_score.php\';",
            "if ( empty( $my_brain ) ) {\n\techo \"Must go home\";\n}"]
        
        static let javaScript = [
            "document.write(\"Keep going!\");",
            "while(true){\n\tdocument.write(\"Work hard!\");\n}",
            "var workHours = { };\nworkHours[\'debugKim\'] = 15;\nworkHours[\'bugWang\'] = 3;",
            "function game(){\n\twhile(true){\n\t\tdocument.write(\"Playing!\");\n\t}\n}",
            "for(var i = 0; i < max; i++){\n\tscore += 777;\n}"]
        
        static let cSharp = [
            "namespace FullStack {\n\tclass State {\n\t\tstatic void Main(string[] args) {\n\t\t\tConsole.WriteLine(\"Good\");\n\t\t}\n\t}\n}",
            "class Faster {\n\tstatic void Main(string[] args) {\n\t\tfor (int i = 0; i < 100; i++) {\n\t\t\tConsole.WriteLine(\"More, More!!\");\n\t\t}\n\t}\n}",
            "static void Main(string[] args) {\n\tstring[] grades = new string[] { \"F\", \"F\", \"F\" };\n\n\tforeach (string s in grades) {\n\t\tConsole.WriteLine(s);\n\t}\n}",
            "class Score {\n\t public int yourScore() {\n\t\treturn 0;\n\t}\n}",
            "class TotalScore {\n\tstatic void Main(string[] args) {\n\t\tint total = 50 + 50\n\t\tConsole.WriteLine(total);\n\t}\n}"]
        
        static let ruby = [
            "24.times do\n\tputs \'Work Hard!\'\nend",
            "if true\n\tputs \'Match!\'\nelse\n\tputs \'Failed!\'\nend",
            "class Worker\n\tdef initialize(name, age)\n\t\t@name = name\n\t\t@age = age\n\tend\nend",
            "for i in 0...max\n\tscore = score + 777\nend",
            "def is_match (unit)\n\tif unit.id == id\n\t\tputs \'Nice!\'\n\tend\nend"]
    }
    
    static func randomCode(for unitId: Int) -> String {
        let targetUnit = UnitInfo.allCases[unitId]
        let randomIndex = Int.random(in: 0..<Codes.totalElement)
        
        switch targetUnit {
        case .swift:
            return Codes.swift[randomIndex]
        case .kotlin:
            return Codes.kotlin[randomIndex]
        case .java:
            return Codes.java[randomIndex]
        case .cPlusPlus:
            return Codes.cPlusPlus[randomIndex]
        case .python:
            return Codes.python[randomIndex]
        case .theC:
            return Codes.theC[randomIndex]
        case .php:
            return Codes.php[randomIndex]
        case .javaScript:
            return Codes.javaScript[randomIndex]
        case .cSharp:
            return Codes.cSharp[randomIndex]
        case .ruby:
            return Codes.ruby[randomIndex]
        }
    }
}
