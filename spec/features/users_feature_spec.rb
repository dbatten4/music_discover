require 'rails_helper'

feature 'user signing and out' do
  before do
    OmniAuth.config.test_mode = true
    # OmniAuth.config.mock_auth[:spotify] = nil
    Rails.application.env_config["omniauth.auth"] = OmniAuth.config.mock_auth[:spotify]
    mock_omniauth_hash
  end

  context 'on homepage' do
    scenario 'can be redirected to /users/index page' do
      visit '/'
      expect(page).to have_link 'Sign in to Grape with Spotify'
    end

    scenario 'can sign in with spotify account' do
      visit '/'
      expect(page).to have_link 'Sign in to Grape with Spotify'
      click_link 'Sign in to Grape with Spotify'
      expect(page).to have_content 'Welcome, test_display_name'
      expect(page).to have_selector :css, "img[src*='test_user_url']"
      expect(page).to have_link 'welcome_logo'
      expect(page).to have_link 'generate_playlist'
      expect(current_path).to eq '/artists/match'
    end
  end

  context 'on artists/match page' do
    scenario 'can navigate to /users/index' do
      visit '/'
      click_link 'Sign in to Grape with Spotify'
      click_link 'welcome_logo'
      expect(page).to have_link 'generate_playlist'
      expect(page).to have_link 'Sign out'
      expect(current_path).to eq '/users/index'
    end

    scenario 'can sign out from Grape' do
      visit '/'
      click_link 'Sign in to Grape with Spotify'
      click_link 'welcome_logo'
      click_link 'Sign out'
      expect(page).not_to have_content 'Welcome, test_display_name'
      expect(page).not_to have_selector :css, "img[src*='test_user_url']"
      expect(page).to have_link 'Sign in to Grape with Spotify'
      expect(page).to have_content 'Signed out from Grape successully. Please note you are still signed in to Spotify.'
      expect(current_path).to eq '/users/index'
    end
  end
end
