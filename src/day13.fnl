(local layers {})

(let [f (assert (io.open :input13))]
  (each [l (f:lines)]
    (let [(ls rs) (l:match "(%d+):%s(%d+)")
          l (tonumber ls)
          r (tonumber rs)]
      (tset layers l r)))
  (f:close))

(var sum 0)
(each [l r (pairs layers)]
  (if (= 0 (% l (- (* r 2) 2)))
      (set sum (+ sum (* l r)))))

(print sum)
