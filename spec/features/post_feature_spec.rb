require "rails_helper"

feature "posts" do

  let!(:user1){ User.create(email: "test@test.com", password: "123456") }

  context "no post available" do

    scenario "user is informed if no post found" do
      visit "/posts"
      expect(page).to have_css("div#yield", text: "No post found")
    end
  end

  context "manage posts" do

    before do

    end

    context "add post" do

      scenario "user cannot add a post if not logged in" do
        visit "/posts"
        click_link("New post")

        expect(current_path).to eq "/users/sign_in"
        expect(page).to have_css("div#alert", text: "You need to sign in or sign up before continuing.")
        expect(page).not_to have_css("div#yield", text: "New post")
      end

      context "logged in" do

        before do
          sign_in
          visit "/posts"
          click_link("New post")
        end

        scenario "user can add post if logged in" do
          expect(current_path).to eq "/posts/new"

          fill_in("Description", with: "it was a nice weekend")
          fill_in("Location", with: "Parliament in Budapest, Hungary")
          attach_file("Image", "spec/assets/photo_01.jpg")
          click_button("Post it")

          expect(page).to have_content("it was a nice weekend")
          expect(page).to have_content("Parliament in Budapest, Hungary")
          expect(page).to have_css("img[src*='photo_01']")
        end

        scenario "user cannot add post w/o description" do
          fill_in("Location", with: "Parliament in Budapest, Hungary")
          attach_file("Image", "spec/assets/photo_01.jpg")
          click_button("Post it")

          expect(page).to have_css("section#errors", text: "Description can't be blank")
        end

        scenario "user cannot add post w/o an image" do
          fill_in("Description", with: "it was a nice weekend")
          fill_in("Location", with: "Parliament in Budapest, Hungary")
          click_button("Post it")

          expect(page).to have_css("section#errors", text: "Image can't be blank")
        end
      end
    end

    context "show post" do

      let!(:post1){ Post.create(description: "visit Budapest", location: "Parliament in Budapest, Hungary", image_file_name: "photo_01.jpg") }

      before do
        sign_in
        visit "/posts"
      end

      scenario "user can see the post on a separate page" do
        click_link "visit Budapest"
        expect(current_path).to eq "/posts/#{post1.id}"
        expect(page).to have_css("div#yield", text: "visit Budapest")
        expect(page).to have_css("div#yield", text: "Parliament in Budapest, Hungary")
        expect(page).to have_css("img[src*='photo_01']")
      end

    end

    context "edit post" do

    end

    context "delete post" do

    end

  end

end
