all: 01/answer 02/answer 03/answer 04/answer 05/answer 06/answer 07/answer \
	08/answer-part-1 10/answer

01/answer: 01/process.rb 01/input
	ruby 01/process.rb > $@

02/answer: 02/process.rb 02/input-test 02/input
	ruby 02/process.rb 02/input-test-description 02/input-test | grep -E '1985'
	ruby 02/process.rb 02/input-description 02/input-test | grep -E '5DB3'
	ruby 02/process.rb 02/input-description 02/input > $@

03/answer: 03/process.rb
	ruby 03/process.rb 03/input > $@

04/answer: 04/sum_sectors.rb 04/room.rb 04/answer-part-2
	ruby 04/sum_sectors.rb 04/input-test | grep -E '1514'
	ruby 04/sum_sectors.rb 04/input > $@

04/answer-part-2: 04/room.rb 04/decrypt_names.rb
	ruby 04/decrypt_names.rb 04/input-test | grep -E 'very encrypted name'
	ruby 04/decrypt_names.rb 04/input | grep 'northpole object storage' > $@

05/answer: 05/bruteforce.rb 05/answer-ordered
	ruby 05/bruteforce.rb abc | grep -E '18f47a30'
	ruby 05/bruteforce.rb ojvtpuvg > $@

05/answer-ordered: 05/bruteforce_ordered.rb
	ruby 05/bruteforce_ordered.rb abc | grep -E '05ace8e3'
	ruby 05/bruteforce_ordered.rb ojvtpuvg > $@

06/answer: 06/process.rb
	ruby 06/process.rb 06/input-test | grep -E 'easter'
	ruby 06/process.rb 06/input-test | grep -E 'advent'
	ruby 06/process.rb 06/input > $@

07/answer: 07/process.rb 07/input-test
	ruby 07/process.rb 07/input-test | grep -E '2'
	ruby 07/process.rb 07/input > $@

08/answer-part-1: 08/answer
	cat 08/answer | tr -Cd '#' | wc -c >$@

08/answer:
	ruby 08/process.rb 08/input > $@

10/answer: 10/process.rb 10/input
	WATCH=1 ruby 10/process.rb 10/input-test | grep -E '1 compared 2 and 3'
	WATCH=1 ruby 10/process.rb 10/input-test | grep -E 'output 2 gets value 3'
	WATCH=1 ruby 10/process.rb 10/input-test | grep -E 'output 0 gets value 5'
	WATCH=2 ruby 10/process.rb 10/input > $@
