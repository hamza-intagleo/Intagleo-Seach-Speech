require 'swagger_helper'

describe 'Users API' do
  path '/users' do
    post 'Creates a User' do
      tags 'User Management'
      consumes 'application/json'
      parameter name: :registration, in: :body, schema: {
        type: :object,
        properties: {
          first_name: { type: :string },
          last_name: { type: :string },
          email: { type: :string },
          password: { type: :string }
        },
        required: [ 'first_name', 'last_name', 'email', 'password' ]
      }

      response '200', 'User is successfully created' do
        run_test!
      end

      response '422', 'Invalid request' do
        run_test!
      end

      response '500', 'Internal server error' do
        run_test!
      end
    end
  end

  path '/users/sign_in' do
    post 'User Sign In' do
      tags 'User Management'
      consumes 'application/json'
      parameter name: :email, :in => :query, :type => :string, :required => true
      parameter name: :password, :in => :query, :type => :string, :required => true

      response '200', 'User is successfully logged in' do
        run_test!
      end

      response '422', 'Invalid user name or password' do
        run_test!
      end

      response '500', 'Internal server error' do
        run_test!
      end
    end
  end

  path '/users/password' do
    post 'Reset Password' do
      tags 'User Management'
      consumes 'application/json'
      parameter name: :email, :in => :query, :type => :string, :required => true

      response '200', 'You will receive an email with instructions on how to reset your password in a few minutes.' do
        run_test!
      end

      response '422', 'Invalid request' do
        run_test!
      end

      response '500', 'Internal server error' do
        run_test!
      end
    end
  end

  path '/users/{user_id}/renew_api_keys' do
    get 'Renew API Keys' do
      tags 'User Management'
      consumes 'application/json'
      parameter name: :email, :in => :path, :type => :integer

      response '200', 'New keys are successfully generated' do
        run_test!
      end

      response '422', 'Invalid request' do
        run_test!
      end

      response '500', 'Internal server error' do
        run_test!
      end
    end
  end

  path '/generate_signature' do
    get 'Generate signature that can be used for API calls' do
      tags 'User Management'
      consumes 'application/json'
      parameter name: :api_key, :in => :header, :type => :string, :required => true
      parameter name: :signature, :in => :header, :type => :string, :required => true

      response '200', '' do
        run_test!
      end

      response '422', 'Invalid request' do
        run_test!
      end

      response '500', 'Internal server error' do
        run_test!
      end
    end
  end
end

describe 'Sites API' do

  path '/users' do
    post 'Creates a User' do
      tags 'Site Management'
      consumes 'application/json'
      parameter name: :user_id, :in => :path, :type => :integer
      parameter name: :site, in: :body, schema: {
        type: :object,
        properties: {
          site_name: { type: :string },
          site_url: { type: :string },
        },
        required: [ 'site_name', 'site_url']
      }

      response '200', 'Site is successfully added' do
        run_test!
      end

      response '422', 'Invalid request' do
        run_test!
      end

      response '500', 'Internal server error' do
        run_test!
      end
    end
  end


  path '/users/{user_id}/sites/{site_id}/add_site_configuration' do
    post 'Add site configuration' do
      tags 'Site Management'
      consumes 'application/json'
      parameter name: :user_id, :in => :path, :type => :integer
      parameter name: :site_id, :in => :path, :type => :integer

      parameter name: :return_results_on_rendered_page, :in => :query, :type => :boolean, :required=> true
      parameter name: :return_results_on_customer_webpage, :in => :query, :type => :boolean, :required=> true
      parameter name: :custom_search_results_url, :in => :query, :type => :string
      parameter name: :search_icon_color, :in => :query, :type => :string
      parameter name: :search_icon_text, :in => :query, :type => :string
      parameter name: :search_box_shape, :in => :query, :type => :string
      parameter name: :search_box_fill_color, :in => :query, :type => :string
      parameter name: :search_box_border_color, :in => :query, :type => :string
      parameter name: :search_box_placeholder_text, :in => :query, :type => :text

      response '200', 'Site configuration is added successfully' do
        run_test!
      end

      response '422', 'Invalid request' do
        run_test!
      end

      response '500', 'Internal server error' do
        run_test!
      end
    end
  end

  path '/users/{user_id}/sites/{site_id}/get_site_configuration' do
    get 'Get site configuration' do
      tags 'Site Management'
      consumes 'application/json'
      parameter name: :user_id, :in => :path, :type => :integer
      parameter name: :site_id, :in => :path, :type => :integer


      response '200', '' do
        run_test!
      end

      response '422', 'Site configuration not found for the site' do
        run_test!
      end

      response '500', 'Internal server error' do
        run_test!
      end
    end
  end


  path '/users/{user_id}/sites/{site_id}/convert_audio_to_text' do
    post 'Convert audio to text' do
      tags 'Site Management'
      consumes 'application/json'

      parameter name: :api_key, :in => :header, :type => :string, :required => true
      parameter name: :signature, :in => :header, :type => :string, :required => true

      parameter name: :user_id, :in => :path, :type => :integer
      parameter name: :site_id, :in => :path, :type => :integer

      parameter name: :audio_file, :in => :query, :type => :file


      response '200', '' do
        run_test!
      end

      response '422', 'Audio is not valid' do
        run_test!
      end

      response '500', 'Internal server error' do
        run_test!
      end
    end
  end


  path '/users/{user_id}/sites/{site_id}/search_text_into_site' do
    get 'Search text into site' do
      tags 'Site Management'
      consumes 'application/json'

      parameter name: :api_key, :in => :header, :type => :string, :required => true
      parameter name: :signature, :in => :header, :type => :string, :required => true

      parameter name: :user_id, :in => :path, :type => :integer
      parameter name: :site_id, :in => :path, :type => :integer

      parameter name: :search_string, :in => :query, :type => :string
      parameter name: :analytics_id, :in => :query, :type => :integer
      


      response '200', '' do
        run_test!
      end

      response '422', 'Not found any thing' do
        run_test!
      end

      response '500', 'Internal server error' do
        run_test!
      end
    end
  end

  path '/users/{user_id}/sites/{site_id}/get_statistics' do
    get 'Get statistics' do
      tags 'Site Management'
      consumes 'application/json'

      parameter name: :api_key, :in => :header, :type => :string, :required => true
      parameter name: :signature, :in => :header, :type => :string, :required => true

      parameter name: :user_id, :in => :path, :type => :integer
      parameter name: :site_id, :in => :path, :type => :integer

      parameter name: :detail_id, :in => :query, :type => :integer
      


      response '200', '' do
        run_test!
      end

      response '422', 'No Statistics Found' do
        run_test!
      end

      response '500', 'Internal server error' do
        run_test!
      end
    end
  end
end
