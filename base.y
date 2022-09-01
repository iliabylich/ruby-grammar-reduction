               maybe<T>: T
                       | none

              repeat<T>: none
                       | T repeat<T>

       at_least_once<T>: T repeat<T>

separated_by<Item, Sep>: none
                       | Item
                       | Item Sep separated_by<Item, Sep>
