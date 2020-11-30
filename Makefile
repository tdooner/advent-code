all: 2020/*/answer

%/answer: %/process.rb
	ruby $*/process.rb $*/test-input | tee | grep -Ef $*/test-answer
	ruby $*/process.rb $*/input | tee $@
