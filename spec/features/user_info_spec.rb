require "rails_helper"

RSpec.feature "UserInfos", type: :feature, js: true do
  let(:user){create :user}

  before do
    login_as user, scope: :user
    @info_user = create :info_user, user: user
    visit user_path(user)
    find(:xpath, '//a[@data-target="tab-information"]').click
  end

  describe "view infomation" do
    it "appear user's introduce" do
      expect(page).to have_content @info_user.introduce
    end

    it "appear user's ambition" do
      expect(page).to have_content @info_user.ambition
    end

    it "appear user's quote if quote not nil" do
      expect(page).to have_content @info_user.quote
    end

    it "appear user's address" do
      expect(page).to have_content @info_user.address
    end

    it "defaut message if quote is nil", skip_before: true do
      @info_user.update_attribute :quote, nil
      visit user_path user
      find(:xpath, '//a[@data-target="tab-information"]').click
      expect(page).to have_content I18n.t "users.social_network.add_quote"
    end
  end

  describe "edit information" do
    context "edit user's introduce" do
      before do
        find(:xpath, '//a[@data-target="#edit-introduction-modal"]').click
      end

      it "show edit introducton modal" do
        expect(page).to have_content I18n.t "info_users.edit_introduction_modal.edit_introduction"
      end

      it "edit introduce success" do
        edited_content = Faker::Lorem.paragraph

        fill_in "Introduce", with: edited_content
        click_button I18n.t "info_users.update.update_button"

        expect(page).to have_content edited_content
      end

      it "edit introduce fail with content has length > 500" do
        edited_content = Faker::Lorem.characters(Settings.info_users.max_length_introduce + 1)

        fill_in "Introduce", with: edited_content
        click_button I18n.t "info_users.update.update_button"

        expect(page).to have_content full_error InfoUser, :quote, :too_long, Settings.info_users.max_length_introduce
      end
    end

    context "edit user's ambition" do
      before do
        find(:xpath, '//a[@data-target="#edit-ambition-modal"]').click
      end

      it "show edit ambition modal" do
        expect(page).to have_content I18n.t "info_users.edit_ambition_modal.edit_ambition"
      end

      it "edit introduce success" do
        edited_content = Faker::Lorem.paragraph

        fill_in "Ambition", with: edited_content
        click_button I18n.t "info_users.update.update_button"

        expect(page).to have_content edited_content
      end

      it "edit ambition fail with content has length > 255" do
        edited_content = Faker::Lorem.characters(Settings.info_users.max_length_ambition + 1)

        fill_in "Ambition", with: edited_content
        click_button I18n.t "info_users.update.update_button"

        expect(page).to have_content full_error InfoUser, :quote, :too_long, Settings.info_users.max_length_ambition
      end
    end

    context "edit about me" do
      before do
        find(:xpath, '//a[@data-target="#edit-about-me-modal"]').click
      end
      it "edit address success" do
        address_content = Faker::Address.city

        fill_in "Address", with: address_content
        click_button I18n.t "info_users.update.update_button"

        expect(page).to have_content address_content
      end

      it "edit address fail with empty address" do
        fill_in "Address", with: ""
        click_button I18n.t "info_users.update.update_button"

        expect(page).to have_content full_error InfoUser, :address, :blank
      end
    end

    context "edit quote" do
      before do
        find(".block-quote").hover
        find(:xpath, '//a[@data-target="#edit-quote-modal"]').click
      end

      it "edit quote success" do
        quote_content = Faker::Lorem.sentence

        fill_in "Quote", with: quote_content
        click_button I18n.t "info_users.update.update_button"

        expect(page).to have_content quote_content
      end

      it "edit quote fail with string has length > max length" do
        quote_content = Faker::Lorem.characters(Settings.info_users.max_length_quote + 1)

        fill_in "Quote", with: quote_content
        click_button I18n.t "info_users.update.update_button"

        expect(page).to have_content full_error InfoUser, :quote, :too_long, Settings.info_users.max_length_quote
      end
    end
  end
end
