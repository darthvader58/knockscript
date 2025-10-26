require_relative 'knockscript'

puts "=" * 50
puts "KnockScript Interpreter Test"
puts "=" * 50

# Test 1: Hello World
puts "\n[Test 1] Hello World"
code1 = 'Knock knock
Who\'s there?
Print
Print who? "Hello, World!"'

result1 = KnockScript.run(code1)
puts result1[:success] ? "✓ PASSED" : "✗ FAILED: #{result1[:error]}"
puts "Output: #{result1[:output]}" if result1[:success]

# Test 2: Variables and Arithmetic
puts "\n[Test 2] Variables and Arithmetic"
code2 = 'Knock knock
Who\'s there?
Set
Set who? x to 10

Knock knock
Who\'s there?
Set
Set who? y to 5

Knock knock
Who\'s there?
Set
Set who? result to x plus y

Knock knock
Who\'s there?
Print
Print who? result'

result2 = KnockScript.run(code2)
puts result2[:success] ? "✓ PASSED" : "✗ FAILED: #{result2[:error]}"
puts "Output: #{result2[:output]}" if result2[:success]

# Test 3: Conditionals
puts "\n[Test 3] Conditionals"
code3 = 'Knock knock
Who\'s there?
Set
Set who? x to 7

Knock knock
Who\'s there?
If
If who? x greater than 5
    Knock knock
    Who\'s there?
    Print
    Print who? "x is greater than 5"
Done'

result3 = KnockScript.run(code3)
puts result3[:success] ? "✓ PASSED" : "✗ FAILED: #{result3[:error]}"
puts "Output: #{result3[:output]}" if result3[:success]

# Test 4: Loops
puts "\n[Test 4] While Loop"
code4 = 'Knock knock
Who\'s there?
Set
Set who? counter to 1

Knock knock
Who\'s there?
While
While who? counter less than 4
    Knock knock
    Who\'s there?
    Print
    Print who? counter
    
    Knock knock
    Who\'s there?
    Set
    Set who? counter to counter plus 1
Done'

result4 = KnockScript.run(code4)
puts result4[:success] ? "✓ PASSED" : "✗ FAILED: #{result4[:error]}"
puts "Output: #{result4[:output]}" if result4[:success]

# Test 5: For Loop
puts "\n[Test 5] For Loop"
code5 = 'Knock knock
Who\'s there?
For
For who? i from 1 to 3
    Knock knock
    Who\'s there?
    Print
    Print who? i
Done'

result5 = KnockScript.run(code5)
puts result5[:success] ? "✓ PASSED" : "✗ FAILED: #{result5[:error]}"
puts "Output: #{result5[:output]}" if result5[:success]

# Test 6: Classes
puts "\n[Test 6] Classes (OOP)"
code6 = 'Knock knock
Who\'s there?
Class
Class who? Person with name

Knock knock
Who\'s there?
Method
Method who? greet for Person
    Knock knock
    Who\'s there?
    Print
    Print who? name
Done

Knock knock
Who\'s there?
Set
Set who? alice to new Person with name "Alice"

Knock knock
Who\'s there?
Call
Call who? greet on alice'

result6 = KnockScript.run(code6)
puts result6[:success] ? "✓ PASSED" : "✗ FAILED: #{result6[:error]}"
puts "Output: #{result6[:output]}" if result6[:success]

puts "\n" + "=" * 50
puts "All tests completed!"
puts "=" * 50