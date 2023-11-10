# frozen_string_literal: true

shared_examples 'internal server error aware action' do
  it 'returns response with internal server error status' do
    make_request
    expect(response).to have_http_status(:internal_server_error)
  end

  it 'renders error message' do
    make_request
    expect(response.body).to match(/ERROR 500: internal server error/)
  end

  it 'logs error' do
    expect(Rails.logger).to receive(:error)
      .with(a_kind_of(String))
      .once
    make_request
  end
end

shared_examples 'not found aware action' do
  it 'returns response with not found status' do
    make_request
    expect(response).to have_http_status(:not_found)
  end

  it 'renders error message' do
    make_request
    expect(response.body).to match(/ERROR 404: not found/)
  end
end
