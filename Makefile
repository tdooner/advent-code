all: 01/answer 02/answer

01/answer: 01/process.rb 01/input
	ruby 01/process.rb > $@

02/answer: 02/process.rb 02/input-test 02/input
	ruby 02/process.rb 02/input-test-description 02/input-test | grep -E '1985'
	ruby 02/process.rb 02/input-description 02/input-test | grep -E '5DB3'
	ruby 02/process.rb 02/input-description 02/input > $@
