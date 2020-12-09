a=ARGF.readlines.map(&:to_i)
p(o=a[(25..a.length).find{|i|!a[(i-25)..i].combination(2).map(&:sum).include?(a[i])}])
def z(a,t,l=2);r=a.each_cons(l).find{|m|m.sum==t};r&&r.min+r.max||z(a,t,l+1);end
p(z(a,o))
