a=ARGF.readlines.map(&:to_i)
p(o=a[(25..a.length).find{|i|!a[i-25..i].combination(2).map(&:sum).include?(a[i])}])
def z(a,t,l=2);a.each_cons(l){|m|return m.min+m.max if m.sum==t};z(a,t,l+1);end
p(z(a,o))
