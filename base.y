              maybe1<T>: T
                       | none

         maybe2<T1, T2>: T1 T2
                       | none

     maybe2<T1, T2, T3>: T1 T2 T3
                       | none

             repeat1<T>: none
                       | T repeat1<T = T>

        repeat2<T1, T2>: none
                       | T1 T2 repeat2<T1 = T1, T2 = T2>

       at_least_once<T>: T repeat1<T = T>

separated_by<Item, Sep>: none
                       | Item
                       | Item Sep separated_by<Item, Sep>

       parenthesized<T>: '(' T ')'

 maybe_parenthesized<T>: T
                       | parenthesized<T>
