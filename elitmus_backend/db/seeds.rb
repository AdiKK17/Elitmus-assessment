# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

users = User.create([
    {
        name: "ronaldo",
        password: "12345",
        email: "ronaldo@mufc.com"
    },
    {
        name: "messi",
        password: "67890",
        email: "messi@psg.com"
    },

])

advertisements = Advertisement.create([
    {
        title: "Audi",
        description: "vorsprung durch technique",
        user: users.first,
    },
    {
        title: "BMW",
        description: "sheer driving pleasure",
        user: users.second
    },
    {
        title: "Mercedes",
        description: "The Best or Nothing",
        user: users.first
    },
])

comments = Comment.create([
    {
        comment: "AUdi is great,ask tony stark",
        advertisement: advertisements.first,
        user: users.first,
    },
    {
        comment: "BMW is magnifique,ask Mission impossible people",
        advertisement: advertisements.second,
        user: users.second,
    },
    {
        comment: "Mercedes is class,ask diplomats",
        advertisement: advertisements.third,
        user: users.first,
    },
])