# frozen_string_literal: true

require 'rails_helper'
require 'support/shared_examples/controller_exceptions_spec'

RSpec.describe ItemsController do
  let(:valid_attributes) do
    {
      title: 'Some title',
      description: 'Some description'
    }
  end

  let(:invalid_attributes) do
    {
      title: ''
    }
  end
  let(:title) { 'Some item' }
  let(:item) { create(:item, title:) }
  let(:index_template_match) { %r{<h1[^>]*>Items</h1>} }
  let(:show_template_match) { %r{<strong>Title:</strong>[[:space:]]*#{title}} }
  let(:new_template_match) { %r{<h1[^>]*>New item</h1>} }
  let(:edit_template_match) { %r{<h1[^>]*>Edit item</h1>} }

  describe '#index' do
    it_behaves_like 'internal server error aware action' do
      let(:make_request) do
        expect(Item).to receive(:with_text_in_title).and_raise('ERROR')
        get items_path
      end
    end

    it 'returns successful response' do
      get items_path
      expect(response).to be_successful
    end

    it 'renders :index template' do
      get items_path
      expect(response.body).to match(index_template_match)
    end
  end

  describe '#show' do
    it_behaves_like 'internal server error aware action' do
      let(:make_request) do
        expect(Item).to receive(:find).and_raise('ERROR')
        get item_path(item)
      end
    end
    it_behaves_like 'not found aware action' do
      let(:make_request) do
        expect(Item).to receive(:find).and_raise(ActiveRecord::RecordNotFound)
        get item_path(item)
      end
    end

    it 'returns successful response' do
      get item_path(item)
      expect(response).to be_successful
    end

    it 'renders :show template' do
      get item_path(item)
      expect(response.body).to match(show_template_match)
    end
  end

  describe '#new' do
    it_behaves_like 'internal server error aware action' do
      let(:make_request) do
        expect(Item).to receive(:new).and_raise('ERROR')
        get new_item_path
      end
    end

    it 'returns successful response' do
      get new_item_path
      expect(response).to be_successful
    end

    it 'renders :new template' do
      get new_item_path
      expect(response.body).to match(new_template_match)
    end
  end

  describe '#create' do
    it_behaves_like 'internal server error aware action' do
      let(:make_request) do
        expect(Item).to receive(:new).and_raise('ERROR')
        post items_path, params: { item: valid_attributes }
      end
    end

    context 'with valid parameters' do
      it 'creates new item' do
        expect do
          post items_path, params: { item: valid_attributes }
        end.to change(Item, :count).by(1)
      end

      it 'sets attributes' do
        post items_path, params: { item: valid_attributes }
        expect(Item.last).to have_attributes(**valid_attributes)
      end

      it 'redirects to items item' do
        post items_path, params: { item: valid_attributes }
        expect(response).to redirect_to(items_path)
      end
    end

    context 'with invalid parameters' do
      it 'does not create new item' do
        expect do
          post items_path, params: { item: invalid_attributes }
        end.not_to change(Item, :count)
      end

      it 'returns response with unprocessable entity status' do
        post items_path, params: { item: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'renders :new template' do
        post items_path, params: { item: invalid_attributes }
        expect(response.body).to match(new_template_match)
      end
    end
  end

  describe '#edit' do
    it_behaves_like 'internal server error aware action' do
      let(:make_request) do
        expect(Item).to receive(:find).and_raise('ERROR')
        get edit_item_path(item)
      end
    end
    it_behaves_like 'not found aware action' do
      let(:make_request) do
        expect(Item).to receive(:find).and_raise(ActiveRecord::RecordNotFound)
        get edit_item_path(item)
      end
    end

    it 'renders successful response' do
      get edit_item_path(item)
      expect(response).to be_successful
    end

    it 'renders :edit template' do
      get edit_item_path(item)
      expect(response.body).to match(edit_template_match)
    end
  end

  describe '#update' do
    it_behaves_like 'internal server error aware action' do
      let(:make_request) do
        expect(Item).to receive(:find).and_raise('ERROR')
        patch item_path(item), params: { item: valid_attributes }
      end
    end
    it_behaves_like 'not found aware action' do
      let(:make_request) do
        expect(Item).to receive(:find).and_raise(ActiveRecord::RecordNotFound)
        patch item_path(item), params: { item: valid_attributes }
      end
    end

    context 'with valid parameters' do
      it 'updates the requested item' do
        patch item_path(item), params: { item: valid_attributes }
        expect(Item.last).to have_attributes(**valid_attributes)
      end

      it 'redirects to the item' do
        patch item_path(item), params: { item: valid_attributes }
        item.reload
        expect(response).to redirect_to(item_path(item))
      end
    end

    context 'with invalid parameters' do
      it 'renders response with unprocessable entity status' do
        patch item_path(item), params: { item: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'renders :edit template' do
        patch item_path(item), params: { item: invalid_attributes }
        expect(response.body).to match(edit_template_match)
      end
    end
  end

  describe '#destroy' do
    it_behaves_like 'internal server error aware action' do
      let(:make_request) do
        expect(Item).to receive(:find).and_raise('ERROR')
        delete item_path(item)
      end
    end
    it_behaves_like 'not found aware action' do
      let(:make_request) do
        expect(Item).to receive(:find).and_raise(ActiveRecord::RecordNotFound)
        delete item_path(item)
      end
    end

    it 'destroys the requested item' do
      item
      expect do
        delete item_path(item)
      end.to change(Item, :count).by(-1)
    end

    it 'redirects to the items list' do
      delete item_path(item)
      expect(response).to redirect_to(items_path)
    end
  end
end
