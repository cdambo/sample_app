require 'spec_helper'

describe "Micropost pages" do

  subject { page }

  let(:user) { FactoryGirl.create(:user) }
  before { sign_in user }

  describe "micropost creation" do
    before { visit root_path }

    describe "with invalid information" do

      it "should not create a micropost" do
        expect { click_button "Post" }.not_to change(Micropost, :count)
      end

      describe "error messages" do
        before { click_button "Post" }
        it { should have_content('error') }
      end
    end

    describe "with valid information" do

      before { fill_in 'micropost_content', with: "Lorem ipsum" }
      it "should create a micropost" do
        expect { click_button "Post" }.to change(Micropost, :count).by(1)
      end
    end
  end

  describe "micropost destruction" do
    before { FactoryGirl.create(:micropost, user: user) }

    describe "as correct user" do
      before { visit root_path }

      it "should delete a micropost" do
        expect { click_link "delete" }.to change(Micropost, :count).by(-1)
      end
    end
  end

  describe "pagination" do
    describe "in home page" do
      before(:each) do
        visit root_path
      end

      before(:all) { 100.times { FactoryGirl.create(:micropost, user: user) } }
      after(:all) { user.microposts.delete_all }

      it { should have_selector('div.pagination') }

      it "should list each micropost" do
        user.microposts.paginate(page: 1).each do |micropost|
          page.should have_selector('li', text: micropost.content)
        end
      end
    end

    describe "in profile page" do
      before(:each) do
        visit user_path(user)
      end

      before(:all) { 100.times { FactoryGirl.create(:micropost, user: user) } }
      after(:all) { user.microposts.delete_all }

      it { should have_selector('div.pagination') }

      it "should list each micropost" do
        user.microposts.paginate(page: 1).each do |micropost|
          page.should have_selector('li', text: micropost.content)
        end
      end
    end
  end
end