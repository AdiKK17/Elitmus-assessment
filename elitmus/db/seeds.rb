# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

advertisements = Advertisement.create([
    {
        title: "Audi",
        description: "vorsprung durch technique"
    },
    {
        title: "BMW",
        description: "sheer driving pleasure"
    },
    {
        title: "Mercedes",
        description: "The Best or Nothing"
    },
])

comments = Comment.create([
    {
        comment: "AUdi is great,ask tony stark",
        advertisement: advertisements.first,
    },
    {
        comment: "BMW is magnifique,ask Mission impossible people",
        advertisement: advertisements.second,
    },
    {
        comment: "Mercedes is class,ask diplomats",
        advertisement: advertisements.third,
    },
])