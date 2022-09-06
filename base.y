              maybe1<T>: T
                       | none

         maybe2<T1, T2>: T1 T2
                       | none

     maybe2<T1, T2, T3>: T1 T2 T3
                       | none

              repeat<T>: none
                       | T repeat<T>

       at_least_once<T>: T repeat<T>

separated_by<Item, Sep>: none
                       | Item
                       | Item Sep separated_by<Item, Sep>

       parenthesized<T>: '(' T ')'

 maybe_parenthesized<T>: T
                       | parenthesized<T>
