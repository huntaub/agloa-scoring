# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_AGLOA_session',
  :secret      => 'cb55d63c31ca18a2282f4d326f5f9e1198e4c2b9c41a798c2b9fd757ad636304f25ed8c243720ec9470cfe446b9874648a12edcedb54fc73ffe5c51f4169df7c'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
