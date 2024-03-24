# frozen_string_literal: true

class AddDeviseToUsers < ActiveRecord::Migration[7.1]
  def self.up
    change_table :users do |t|
      ## Database authenticatable
      unless column_exists?(:users, :email)
        t.string :email, null: false, default: ""
      end
      unless column_exists?(:users, :encrypted_password)
        t.string :encrypted_password, null: false, default: ""
      end

      ## Recoverable
      add_column :users, :reset_password_token, :string unless column_exists?(:users, :reset_password_token)
      add_column :users, :reset_password_sent_at, :datetime unless column_exists?(:users, :reset_password_sent_at)

      ## Rememberable
      add_column :users, :remember_created_at, :datetime unless column_exists?(:users, :remember_created_at)

      ## Trackable
      # Ajoutez des vérifications similaires pour les autres colonnes si vous souhaitez les activer
    end

    # Ajout des index uniquement si les colonnes existent et ne possèdent pas déjà un index unique
    unless index_exists?(:users, :email, unique: true)
      add_index :users, :email, unique: true
    end
    unless index_exists?(:users, :reset_password_token, unique: true)
      add_index :users, :reset_password_token, unique: true
    end
    # Répétez pour les autres index si nécessaire
  end

  def self.down
    # Vous pouvez ici ajouter des instructions pour supprimer les colonnes si vous souhaitez rendre cette migration réversible.
    # Par exemple :
    # remove_column :users, :encrypted_password if column_exists?(:users, :encrypted_password)
    # Notez que supprimer :email pourrait être délicat si d'autres parties de votre application s'y fient.

    # Si vous avez ajouté des colonnes ou des index optionnels, assurez-vous de les gérer ici également.
  end
end

