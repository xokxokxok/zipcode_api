user = User.new(
  role: 'admin',
  name: 'Admin',
  email: 'admin@admin.com',
  password: 'admin123456',
  password_confirmation: 'admin123456'
)
user.save!
