# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Plan.find_or_create_by!(plan_name: "free", query_limit: 250, price: 0.0, duration_type: "2 weeks")
Plan.find_or_create_by!(plan_name: "basic", query_limit: 5000, price: 19.99, duration_type: "per month")
Plan.find_or_create_by!(plan_name: "standard", query_limit: 10000, price: 39.99, duration_type: "per month")
Plan.find_or_create_by!(plan_name: "enterprise", query_limit: -1, price: 0.004, duration_type: "per query")