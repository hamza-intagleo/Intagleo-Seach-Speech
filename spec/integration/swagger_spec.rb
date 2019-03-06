require 'swagger_helper'

describe 'Users API' do
  path '/users' do
    post 'Creates a User' do
      tags 'User Management'
      consumes 'multipart/form-data'
      description "This API method will be used to create a user. In response it will provide the API key and shared secret key which can be used to generate signature."

      parameter name: "user[first_name]", :in => :formData, :type => :string, :required => true
      parameter name: "user[last_name]", :in => :formData, :type => :string, :required => true
      parameter name: "user[email]", :in => :formData, :type => :string, :required => true
      parameter name: "user[password]", :in => :formData, :type => :string, :required => true
      # parameter name: :user, in: :body, description: "Body parameters for this call", schema: {
      #   type: :object,
      #   properties: {
      #     "user[first_name]": { type: :string },
      #     "user[last_name]": { type: :string },
      #     "user[email]": { type: :string },
      #     "user[password]": { type: :string }
      #   },
      #   required: [ 'first_name', 'last_name', 'email', 'password' ]
      # }

      response '200', 'User is successfully created' do
        run_test!
      end

      response '422', 'Email is invalid' do
        run_test!
      end

      response '409', 'Email has already been taken' do
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
      # consumes 'application/json'
      consumes 'multipart/form-data'
      description "This API method will be used to login the user providing the below input parameters."
      parameter name: "user[email]", :in => :formData, :type => :string, :required => true
      parameter name: "user[password]", :in => :formData, :type => :string, :required => true

      # parameter name: :email, :in => :query, :type => :string, :required => true, :description => "Enter email address"
      # parameter name: :password, :in => :query, :type => :string, :required => true, :description => "Enter password"

      response '200', 'User is successfully logged in' do
        run_test!
      end

      response '401', 'Invalid Email or password.' do
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
      consumes 'multipart/form-data'
      description "This API method will be used to resets the user's password. This method will send an email to provided email address for futher steps."
      parameter name: "user[email]", :in => :formData, :type => :string, :required => true, :description => "Enter email address"

      response '200', 'You will receive an email with instructions on how to reset your password in a few minutes.' do
        run_test!
      end

      response '422', 'Email not found' do
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
      description 'This API method will be used to re generate API key and shared secret key. Please note that you need to re generate the signature using these new keys.'
      parameter name: :user_id, :in => :path, :type => :integer, :description => "Enter user ID"
      parameter name: :email, :in => :path, :type => :integer, :description => "Enter email address"

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
      description "This API method will be used to generate signature which will be used as a header in the calls for authorization."
      parameter name: :api_key, :in => :query, :type => :string, :required => true, :description => "Enter API key"
      parameter name: :shared_secret, :in => :query, :type => :string, :required => true, :description => "Enter shared secret key"
      parameter name: :timestamp, :in => :query, :type => :string, :required => true, :description => "Current Timestamp i.e #{Time.now.to_i}"

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

  path '/users/{user_id}/sites' do
    post 'Add a Site' do
      tags 'Site Management'
      consumes 'application/json'
      description "This API method will be used to add a new site for provided user."
      parameter name: :user_id, :in => :path, :type => :integer, :description => "Enter user ID"
      parameter name: :site, in: :body, description: "Site parameters", schema: {
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
      description "This API method will be used to add a configuration settings for provided site."
      parameter name: :user_id, :in => :path, :type => :integer, :description => "Enter user ID"
      parameter name: :site_id, :in => :path, :type => :integer, :description => "Enter site ID"

      parameter name: :site_configuration, in: :body, description: "Site configuration parameters", schema: {
        type: :object,
        properties: {
          return_results_on_rendered_page: { type: :boolean },
          return_results_on_customer_webpage: { type: :boolean },
          custom_search_results_url: { type: :string },
          search_icon_color: { type: :string },
          search_icon_text: { type: :string },
          search_box_shape: { type: :string },
          search_box_fill_color: { type: :string },
          search_box_border_color: { type: :string },
          search_box_placeholder_text: { type: :string },

        },
        required: [ 'return_results_on_rendered_page', 'return_results_on_customer_webpage']
      }

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
      description "This method will be used to get the configuration of any site."
      parameter name: :user_id, :in => :path, :type => :integer, :description => "Enter user ID"
      parameter name: :site_id, :in => :path, :type => :integer, :description => "Enter site ID"


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
      consumes 'multipart/form-data'
      description "This API method will be used to convert audio speech file into text."

      parameter name: :api_key, :in => :header, :type => :string, :required => true, :description => "Enter API Key"
      parameter name: :signature, :in => :header, :type => :string, :required => true, :description => "Enter Signature"
      parameter name: :timestamp, :in => :header, :type => :string, :required => true, :description => "Enter Timestamp"

      parameter name: :user_id, :in => :path, :type => :integer, :description => "Enter user ID"
      parameter name: :site_id, :in => :path, :type => :integer, :description => "Enter site ID"


      parameter name: :audio_file, :in => :formData, :type => :file


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
      description "This API method will be used to search into site url with converted speech text."

      parameter name: :api_key, :in => :header, :type => :string, :required => true, :description => "Enter API key"
      parameter name: :signature, :in => :header, :type => :string, :required => true, :description => "Enter Signature"
      parameter name: :timestamp, :in => :header, :type => :string, :required => true, :description => "Current Timestamp i.e #{Time.now.to_i}"

      parameter name: :user_id, :in => :path, :type => :integer, :description => "Enter user ID"
      parameter name: :site_id, :in => :path, :type => :integer, :description => "Enter site ID"

      parameter name: :search_string, :in => :query, :type => :string, :description => "Enter converted speech text"
      parameter name: :analytics_id, :in => :query, :type => :integer, :description => "Enter analytics ID retrieved from previous call (i.e convert_audio_to_text)."
      


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
      description "This API method will be used to retrieved the statistics of a site provided."

      parameter name: :api_key, :in => :header, :type => :string, :required => true, :description => "Enter API key"
      parameter name: :signature, :in => :header, :type => :string, :required => true, :description => "Enter Signature"
      parameter name: :timestamp, :in => :header, :type => :string, :required => true, :description => "Enter Timestamp"

      parameter name: :user_id, :in => :path, :type => :integer, :description => "Enter user ID"
      parameter name: :site_id, :in => :path, :type => :integer, :description => "Enter site ID"

      parameter name: :detail_id, :in => :query, :type => :integer, :description => "Enter detail ID from the following options: \n 1- Number of Searches Per Minute / Past 24 Hours \n 2- Total Searches \n 3- Average Searches / Minute \n 4- Average Search Response Time \n 5- Average Text Processing Time \n 6- List all Searches \n 7- List all Text Conversion Times e.g. Job 1, Start, End, Time \n 8- All Stats "
      


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
