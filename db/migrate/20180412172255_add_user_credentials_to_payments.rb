class AddUserCredentialsToPayments < ActiveRecord::Migration[5.1]
  def change
    add_column :payments, :first_name, :string
    add_column :payments, :last_name, :string
    add_column :payments, :email, :string
    add_column :payments, :phone, :string
    add_column :payments, :note, :string
    
  end
end
