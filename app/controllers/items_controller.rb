# frozen_string_literal: true

# Items controller
class ItemsController < ApplicationController
  def index
    %i[searched start_date end_date sorting_column sorting_direction].each do |key|
      session[key] = params[key] if params.key?(key)
    end
    @items = items_query
  rescue StandardError => e
    internal_server_error(e)
  end

  def show
    @item = Item.find(params[:id])
  rescue ActiveRecord::RecordNotFound => e
    not_found(e)
  rescue StandardError => e
    internal_server_error(e)
  end

  def new
    @item = Item.new
  rescue StandardError => e
    internal_server_error(e)
  end

  def edit
    @item = Item.find(params[:id])
  rescue ActiveRecord::RecordNotFound => e
    not_found(e)
  rescue StandardError => e
    internal_server_error(e)
  end

  def create
    @item = Item.new(item_params)
    @item.save!
    @item = Item.new
    redirect_to items_path, notice: t('.success'), status: :see_other
  rescue ActiveRecord::RecordInvalid
    render :new, alert: t('.record_invalid'), status: :unprocessable_entity
  rescue StandardError => e
    internal_server_error(e)
  end

  def update
    @item = Item.find(params[:id])
    @item.update!(item_params)
    redirect_to @item, notice: t('.success'), status: :see_other
  rescue ActiveRecord::RecordInvalid
    render :edit, alert: t('.record_invalid'), status: :unprocessable_entity
  rescue ActiveRecord::RecordNotFound => e
    not_found(e)
  rescue StandardError => e
    internal_server_error(e)
  end

  def destroy
    Item.find(params[:id]).destroy!
    redirect_to items_path, notice: t('.success'), status: :see_other
  rescue ActiveRecord::RecordNotFound => e
    not_found(e)
  rescue StandardError => e
    internal_server_error(e)
  end

  private

  def item_params
    params.require(:item).permit(:title, :description)
  end

  def basic_items_query
    Item.with_text_in_title(session[:searched])
      .or(Item.searched_in_description(session[:searched]).unscope(:select, :order))
  end

  def items_query
    basic_items_query
      .from_date_or_newer_than(session[:start_date])
      .from_date_or_older_than(session[:end_date])
      .ordered(session[:sorting_column], session[:sorting_direction])
  end
end
