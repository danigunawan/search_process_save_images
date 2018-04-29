require 'rails_helper'

RSpec.describe ImagesController, type: :controller do

  let(:valid_attributes) { Fabricate.to_params(:image) }
  let(:invalid_attributes) { Fabricate.to_params(:image, associated_image: nil) }


  describe "GET #index" do
    it "returns a success response" do
      image = Image.create! valid_attributes
      get :index
      expect(response).to be_success
    end
  end

  describe "GET #show" do
    it "returns a success response" do
      image = Image.create! valid_attributes
      get :show, params: {id: image.to_param}
      expect(response).to be_success
    end
  end

  describe "GET #new" do
    it "returns a success response" do
      get :new
      expect(response).to be_success
    end
  end

  describe "GET #edit" do
    it "returns a success response" do
      image = Image.create! valid_attributes
      get :edit, params: {id: image.to_param}
      expect(response).to be_success
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new Image" do
        expect {
          post :create, params: {image: valid_attributes}
        }.to change(Image, :count).by(1)
        expect(Image.last.associated_image.file?).to eq(true)
      end

      it "redirects to the created image" do
        post :create, params: {image: valid_attributes}
        expect(response).to redirect_to(Image.last)
      end
    end

    context "with invalid params" do
      it "returns a success response (i.e. to display the 'new' template)" do
        post :create, params: {image: invalid_attributes}
        expect(response).to be_success
      end
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      it "redirects to the image" do
        image = Image.create! valid_attributes
        put :update, params: {id: image.to_param, image: valid_attributes}
        expect(response).to redirect_to(image)
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested image" do
      image = Image.create! valid_attributes
      expect {
        delete :destroy, params: {id: image.to_param}
      }.to change(Image, :count).by(-1)
    end

    it "redirects to the images list" do
      image = Image.create! valid_attributes
      delete :destroy, params: {id: image.to_param}
      expect(response).to redirect_to(images_url)
    end
  end

end
