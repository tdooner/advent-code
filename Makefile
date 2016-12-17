all: 01/answer 02/answer 03/answer 04/answer 05/answer 06/answer 07/answer \
	08/answer-part-1 09/answer 10/answer 12/answer 13/answer 14/answer 15/answer \
	16/answer

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

09/answer: 09/process.rb
	ruby 09/process.rb 09/input-test | grep '0: 6'
	ruby 09/process.rb 09/input-test | grep '1: 7'
	ruby 09/process.rb 09/input-test | grep '2: 9'
	ruby 09/process.rb 09/input-test | grep '3: 11'
	ruby 09/process.rb 09/input-test | grep '4: 6'
	ruby 09/process.rb 09/input-test | grep '5: 18'
	VERSION=2 ruby 09/process.rb 09/input-test | grep '5: 20'
	echo "part 1: " >$@
	ruby 09/process.rb 09/input | sed -e 's/0: //' >> $@
	echo "part 2: " >>$@
	VERSION=2 ruby 09/process.rb 09/input | sed -e 's/0: //' >> $@

10/answer: 10/process.rb 10/input
	WATCH=1 ruby 10/process.rb 10/input-test | grep -E '1 compared 2 and 3'
	WATCH=1 ruby 10/process.rb 10/input-test | grep -E 'output 2 gets value 3'
	WATCH=1 ruby 10/process.rb 10/input-test | grep -E 'output 0 gets value 5'
	WATCH=2 ruby 10/process.rb 10/input > $@

11/answer:
	ruby 11/process.rb 11/input-test | grep '11'
	ruby 11/process.rb 11/input >$@

12/answer:
	ruby 12/process.rb 12/input-test | grep '42'
	echo "part 1:" > $@
	ruby 12/process.rb 12/input >>$@
	echo "part 2:" >> $@
	C=1 ruby 12/process.rb 12/input >>$@

13/answer:
	ruby 13/process.rb 10 7,4 | head -n 1 | grep '11'
	echo "part 1:" > $@
	ruby 13/process.rb 1358 31,39 >>$@
	echo "part 2:" >> $@
	MODE=distance ruby 13/process.rb 1358 31,39 >>$@

14/answer: 14/process.rb
	ruby 14/process.rb abc | grep '22728'
	echo "part 1:" > $@
	ruby 14/process.rb ngcjuoqr >>$@
	STRETCH=2016 ruby 14/process.rb abc | grep '22551'
	echo "part 2:" > $@
	STRETCH=2016 ruby 14/process.rb ngcjuoqr >>$@

15/answer: 15/process.rb
	ruby 15/process.rb 15/input-test | grep '5'
	echo "part 1:" > $@
	ruby 15/process.rb 15/input >>$@
	echo "part 2:" >> $@
	ruby 15/process.rb 15/input-part-2 >>$@

16/answer: 16/process.rb
	ruby 16/process.rb ihgpwlah | grep -E '^DDRRRD$$'
	ruby 16/process.rb kglvqrro | grep -E '^DDUDRLRRUDRD$$'
	ruby 16/process.rb kglvqrro | grep -E '^DDUDRLRRUDRD$$'
	ruby 16/process.rb pgflpeqp >$@
