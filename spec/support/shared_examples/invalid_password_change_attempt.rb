# frozen_string_literal: true

shared_examples 'invalid password change attempt' do
  it 'does not change user password' do
    expect { perform_request }.not_to(change { user.reload.encrypted_password })
  end

  it 'responds with an error message' do
    perform_request

    expect(response).to have_http_status(:unprocessable_entity)
    expect(json).to include(expected_error)
  end
end
