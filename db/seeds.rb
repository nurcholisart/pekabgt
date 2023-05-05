# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

Tenant.find_or_create_by!(code: "ergav-4oqumerwmn4r1ud") do |t|
  t.name = "Qiscus Presale"
  t.admin_email = "ergav-4oqumerwmn4r1ud_admin@qismo.com"
  t.active = true
  t.code = "ergav-4oqumerwmn4r1ud"
  t.secret_key = "393d74954a7d6a60a77b7568c757068a"
  t.admin_token = "QFyK7koq2mhxps7Z6Xpd"
  t.admin_sdk_token = "uAJSvzRNSYMIqwKsciP51623829686"
end

Embedding.create