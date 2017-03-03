require 'google/apis/gmail_v1'
require 'googleauth'
require 'googleauth/stores/file_token_store'

require 'fileutils'

class Gmail

  OOB_URI = 'urn:ietf:wg:oauth:2.0:oob'
  APPLICATION_NAME = 'Gmail API Ruby Quickstart'
  CLIENT_SECRETS_PATH = 'client_secret.json'
  CREDENTIALS_PATH = File.join(Dir.home, '.credentials',
                               "gmail-ruby-quickstart.yaml")
  SCOPE = Google::Apis::GmailV1::AUTH_GMAIL_READONLY

  ##
  # Ensure valid credentials, either by restoring from the saved credentials
  # files or intitiating an OAuth2 authorization. If authorization is required,
  # the user's default browser will be launched to approve the request.
  #
  # @return [Google::Auth::UserRefreshCredentials] OAuth2 credentials

  def authorize
    FileUtils.mkdir_p(File.dirname(CREDENTIALS_PATH))

    client_id = Google::Auth::ClientId.from_file(CLIENT_SECRETS_PATH)
    token_store = Google::Auth::Stores::FileTokenStore.new(file: CREDENTIALS_PATH)
    authorizer = Google::Auth::UserAuthorizer.new(
      client_id, SCOPE, token_store)
    user_id = 'default'
    credentials = authorizer.get_credentials(user_id)
    if credentials.nil?
      url = authorizer.get_authorization_url(
        base_url: OOB_URI)
      puts "Open the following URL in the browser and enter the " +
           "resulting code after authorization"
      puts url
      code = gets
      credentials = authorizer.get_and_store_credentials_from_code(
        user_id: user_id, code: code, base_url: OOB_URI)
    end
    credentials
  end


  def get_emails(query, max_results)
    # Initialize the API
    service = Google::Apis::GmailV1::GmailService.new
    service.client_options.application_name = APPLICATION_NAME
    service.authorization = authorize

  # Show the user's message list
    result = service.list_user_messages('me', options = {q: query, max_results: max_results})

    id_list = []

    result.messages.each do |message|
      id_list << message.id
    end

    email_list = {}
    id_list.each do |id|
      date = service.get_user_message('me', id, options = {format: 'metadata', metadata_headers: 'Date'}).payload.headers[0].value
      from = service.get_user_message('me', id, options = {format: 'metadata', metadata_headers: 'From'}).payload.headers[0].value
      to = service.get_user_message('me', id, options = {format: 'metadata', metadata_headers: 'To'}).payload.headers[0].value
      subject = service.get_user_message('me', id, options = {format: 'metadata', metadata_headers: 'Subject'}).payload.headers[0].value
      email_list[date] = {from: from, to: to, subject: subject}
    end

    email_list

  end
end
