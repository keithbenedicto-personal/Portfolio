# Creation of appsync
provider "aws" {
  alias = "module"
  region = "${var.aws_region}"

  assume_role {
    role_arn = "${var.iam_role}"
  }
}
resource "aws_appsync_graphql_api" "seahzn-appsync" {
    authentication_type = "API_KEY"
    name                = "${var.project_name}-shared-online-appsync-${var.tag_environment}-${var.env_version}"
    schema              = <<EOF
 type Agent {
	agentCognitoId: ID!
	userName: String!
	workerId: String!
}

type AvailableAgents @aws_api_key
@aws_cognito_user_pools
@aws_iam {
	requestId: String
	availableAgents: Int
	startTimestamp: String
}

type CannedMessage {
	cannedMessageId: ID!
	categoryId: ID!
	content: String!
	hotKey: String
	isActive: Boolean!
	languageCode: String!
	skillId: ID!
	title: String!
}

type Category {
	categoryId: ID!
	languageCode: String!
	messages(skillId: ID!): [CannedMessage]
	name: String!
}

type ChatActivity {
	Active: Boolean!
	ActivityName: String!
	ActivityTimeStamp: String!
	ActivityType: String
	Duration: String
	UserEmail: String!
}

type ChatAudit {
	auditLog: String!
	chatAuditId: ID!
	createdAt: String!
	expertName: String
	requestId: ID!
	visitorId: ID!
}

type ChatAuditConnection {
	items: [ChatAudit]
	nextToken: String
}

type ChatRequest {
	averageResponseTime: String
	averageUserResponseTime: String
	caseNumber: String
	browserAgent: String
	chatReason: String!
	chatWaitTime: Float
	claimNumber: String
	clientName: String!
	comments: String
	customerId: String
	endTimestamp: String
	engagementDuration: String
	engagementType: String
	expertName: String
	interactionId: ID
	isTransferred: Boolean
	languageCode: String!
	mdn: String
	policyNumber: String
	rating: AWSJSON
	requestId: ID!
	requestStatus: String
	requestType: String
	skillId: String!
	speedToAnswer: String
	startTimestamp: String!
	storeCode: String
	taskId: ID
	transferredRequestId: String
	userEmail: String
	userProfileUrl: String
	violationCount: String
	visitorId: ID!
	visitorName: String!
	wrapUpCode: String
	ARN: String
	OSType: String
	deviceId: String
	appInBackground: Boolean
	requestChannel: String
	chatAcceptTimeStamp: String
}

type ChatRequestConnection {
	items: [ChatRequest]
	nextToken: String
}

type ChatRequestStatus {
	status: String!
	statusId: ID!
}

type Conversation {
	agentCognitoId: ID!
	agentTyping: Boolean
	conversationId: ID!
	createdAt: String!
	endTimestamp: String
	messages(conversationId: ID!): MessageConnection
	requestId: ID!
	visitorId: ID!
	visitorTyping: Boolean
}

input CreateChatActivity {
	Active: Boolean!
	ActivityName: String!
	ActivityTimeStamp: String!
	ActivityType: String
	Duration: String
	UserEmail: String!
}

input CreateChatAudit {
	auditLog: String!
	createdAt: String!
	expertName: String
	requestId: ID!
	visitorId: ID!
}

input CreateChatRequestInput {
	averageResponseTime: String
	caseNumber: String
	browserAgent: String
	chatReason: String!
	chatWaitTime: Float
	claimNumber: String
	clientName: String!
	comments: String
	customerId: String
	endTimestamp: String
	engagementDuration: String
	engagementType: String
	interactionId: ID
	languageCode: String!
	mdn: String
	policyNumber: String
	requestId: ID!
	requestStatus: String
	requestType: String
	skillId: String!
	startTimestamp: String!
	storeCode: String
	taskId: ID
	userEmail: String
	userProfileUrl: String
	violationCount: String
	visitorId: ID!
	visitorName: String!
	wrapUpCode: String
	ARN: String
	OSType: String
	deviceId: String
	appInBackground: Boolean
	requestChannel: String
}

input CreateConversationInput {
	agentCognitoId: ID!
	conversationId: ID!
	createdAt: String!
	endTimestamp: String
	requestId: ID!
	visitorId: ID!
}

input CreateCustomerMemo {
	content: String!
	createdAt: String
	createdBy: String
	mdn: ID!
}

input CreateMessageInput {
	agentResponseTime: String
	content: String!
	conversationId: ID
	createdAt: String!
	interactionType: String!
	isActive: Boolean
	isSent: Boolean!
	messageId: ID!
	messageType: String!
	recipient: String!
	sender: String!
	serialNo: Int
	source: String!
	sourceLang: String
	sourceMsgId: ID
	targetLang: String
	translated: Boolean
	violated: String
	visitorId: ID!
	messageStatus: String
	skillId: String
}

input CreateVideoAudit {
	auditLog: String!
	expertName: String
	requestId: ID!
	visitorId: ID!
}

input CreateVideoRequestInput {
	requestId: String!
	taskId: String
	visitorId: String
	roomId: String
	carrier: String
	expertToken: String
	clientToken: String
	chatRequestId: String
	expertId: String
}

input CreateVisitorInput {
	browserAgent: String!
	clientId: String!
	imei: String
	interactionId: ID
	ipAddress: String!
	journeyStatus: String!
	languageCode: String!
	mdn: String
	policyNumber: String
	startTimestamp: String!
	userName: String!
	visitorCognitoId: ID!
	visitorId: ID!
	source: String
	interactionType: String
	carrierName: String
	lastUpdatedTime: String
	chatAssisted: String
	lastActivity: String
	caseNumber: String
	perilType: String
	chatReason: String
}

type CustomerMemo {
	content: String!
	createdAt: String
	createdBy: String
	mdn: ID!
	updatedAt: String
	updatedBy: String
}

input EndVideoCallInput {
	requestId: String!
}

type Message {
	agentResponseTime: String
	userResponseTime: String
	content: String!
	conversationId: ID
	createdAt: String!
	interactionType: String!
	isActive: Boolean
	isSent: Boolean!
	messageId: ID!
	messageType: String!
	recipient: String!
	sender: String!
	source: String!
	sourceLang: String
	sourceMsgId: ID
	targetLang: String
	translated: Boolean
	violated: String
	visitorId: ID!
	messageStatus: String
	skillId: String
}

type MessageConnection {
	items: [Message]
	nextToken: String
}

type Mutation @aws_api_key
@aws_cognito_user_pools
@aws_iam {
	createChatActivity(input: CreateChatActivity!): ChatActivity
	createChatAudit(input: CreateChatAudit!): ChatAudit
	createVideoAudit(input: CreateVideoAudit!): VideoAudit
	createConversation(input: CreateConversationInput!): Conversation
	createCustomerMemo(input: CreateCustomerMemo!): CustomerMemo
	createEncryptedChatRequest(input: CreateChatRequestInput!): ChatRequest
	createMessage(input: CreateMessageInput!): Message
	createTranslatedMessage(input: CreateMessageInput!): Message
	createVisitor(input: CreateVisitorInput!): Visitor
	createVideoRequest(input: CreateVideoRequestInput!): VideoRequest
	endVideoCall(input: EndVideoCallInput!): VideoRequest
	updateAgentTyping(input: UpdateAgentTypingInput!): Conversation
	updateConversation(input: UpdateConversationInput!): Conversation
	updateCustomerMemo(input: UpdateCustomerMemo!): CustomerMemo
	updateEncryptedChatRequest(input: UpdateChatRequestInput!): ChatRequest
	updateMessage(input: UpdateMessageInput!): Message
	updateVideoRequest(input: UpdateVideoRequest!): VideoRequest
	updateAvailableAgents(input: UpdateAvailableAgents!): AvailableAgents
	updateUserMessageResponseTime(input: UpdateUserMessageResponseTimeInput!): Message
	updateVisitor(input: UpdateVisitorInput!): Visitor
	updateVisitorTyping(input: UpdateVisitorTypingInput!): Conversation
	updateVoiceRequest(input: UpdateVoiceRequest!): VoiceRequest
}

type Query @aws_api_key
@aws_cognito_user_pools
@aws_iam {
	getAgent(cognitoId: ID!): Agent
	getAllChatRequest: [ChatRequest]
	getAllChatRequestWithLimit: ChatRequestConnection
	getAllOnlineVisitors(input: SearchParams): [Visitor]
	getAllStatus: [ChatRequestStatus]
	getCannedMessages(languageCode: String!, skillId: ID!): [Category]
	getChatAudit(requestId: ID!, visitorId: ID!): [ChatAudit]
	getVideoAuditByRequestId(requestId: ID!): [VideoAudit]
	getChatRequestByParams(input: SearchParams): [ChatRequest]
	getChatRequestByParamsTemp(input: SearchParamsTemp): [ChatRequest]
	getChatRequestDetails(visitorId: ID): ChatRequest
	getConversation(requestId: ID!): Conversation
	getConversationMessages(conversationId: ID!): MessageConnection
	getCustomerMemo(mdn: String!): CustomerMemo
	getEncryptedChatRequest(requestId: ID): ChatRequest
	getJourneyMessages(visitorId: ID!): [Message]
	getMessagesForRequest(requestId: ID!): [Message]
	getVideoRequest(requestId: String!): VideoRequest
	getVideoRequests(input: VideoSearchParams!): [VideoRequest]
	getVideoRequestsByMDN(mdn: String!): [VideoRequest]
	getVideoRequestsByVisitorId(visitorId: String!): [VideoRequest]
	getVideoRequestByRoomId(roomId: String!): VideoRequest
	getVoiceAudits(requestId: String!): [VoiceAudit]
	getVoiceRequests(input: VoiceSearchParams!): [VoiceRequest]
	getVoiceRequestByCallId(callSid: String!): VoiceRequest
	getVisitor(visitorId: ID!): Visitor
	getVisitorsByMDN(mdn: String!): [ChatRequest]
	getVoiceRequestPaginated(input: VoiceSearchParams!, nextToken: String): VoiceRequestPaginated
}

input SearchParams {
	caseNumber: String
	clientId: String
	clientName: String
	engagementType: String
	expertName: String
	fromDate: String
	journeyStatus: String
	mdn: String
	policyNumber: String
	requestStatus: String
	searchBy: String
	storeCode: String
	toDate: String
	wrapUpCode: String
}

input SearchParamsTemp {
	caseNumber: String
	clientId: String
	clientName: [String]
	engagementType: String
	expertName: String
	fromDate: String
	journeyStatus: String
	mdn: String
	policyNumber: String
	requestStatus: String
	searchBy: String
	storeCode: String
	toDate: String
	wrapUpCode: String
}

type Subscription @aws_api_key
@aws_cognito_user_pools
@aws_iam {
	onAgentTyping(conversationId: ID!): Conversation
		@aws_subscribe(mutations: ["updateAgentTyping"])
	onCreateChatActivity(UserEmail: String!): ChatActivity
		@aws_subscribe(mutations: ["createChatActivity"])
	onCreateConversation(requestId: ID!): Conversation
		@aws_subscribe(mutations: ["createConversation"])
	onCreateMessage(conversationId: ID!): Message
		@aws_subscribe(mutations: ["createMessage","createTranslatedMessage"])
	onCreateOrUpdateChatRequest(requestStatus: String!): ChatRequest
		@aws_subscribe(mutations: ["createEncryptedChatRequest","updateEncryptedChatRequest"])
	onCreateVideoRequest(requestId: String!): VideoRequest
		@aws_subscribe(mutations: ["createVideoRequest"])
	onEndVideoRequest(requestId: String!): VideoRequest
		@aws_subscribe(mutations: ["endVideoCall"])
	onUpdateChatRequest(requestId: ID): ChatRequest
		@aws_subscribe(mutations: ["updateEncryptedChatRequest"])
	onUpdateConversation(conversationId: ID): Conversation
		@aws_subscribe(mutations: ["updateConversation"])
	onUpdateVideoRequest(requestId: String!): VideoRequest
		@aws_subscribe(mutations: ["updateVideoRequest"])
	onCreateOrUpdateVideoRequest(requestId: String!): VideoRequest
		@aws_subscribe(mutations: ["createVideoRequest","updateVideoRequest"])
	onCreateVideoRequestOnChat(chatRequestId: String!, visitorId: String): VideoRequest
		@aws_subscribe(mutations: ["createVideoRequest"])
	onVisitorTyping(conversationId: ID!): Conversation
		@aws_subscribe(mutations: ["updateVisitorTyping"])
	onUpdateAvailableAgents(requestId: String!): AvailableAgents
		@aws_subscribe(mutations: ["updateAvailableAgents"])
	onUpdateMessage(conversationId: ID!): Message
		@aws_subscribe(mutations: ["updateMessage","updateUserMessageResponseTime"])
	onUpdateVideoRequestStatus(requestId: String!, status: String!): VideoRequest
		@aws_subscribe(mutations: ["updateVideoRequest"])
	onUpdateVoiceRequest(requestId: String, chatRequestId: String): VoiceRequest
		@aws_subscribe(mutations: ["updateVoiceRequest"])
}

input UpdateAgentTypingInput {
	agentTyping: Boolean!
	conversationId: ID!
}

input UpdateAvailableAgents {
	requestId: String!
	availableAgents: Int
}

input UpdateChatRequestInput {
	averageResponseTime: String
	averageUserResponseTime: String
	caseNumber: String
	chatWaitTime: Float
	claimNumber: String
	comments: String
	customerId: String
	endTimestamp: String
	engagementDuration: String
	expertName: String
	interactionId: ID
	isTransferred: Boolean
	mdn: String
	policyNumber: String
	rating: AWSJSON
	requestId: ID!
	requestStatus: String
	requestType: String
	speedToAnswer: String
	taskId: ID
	transferredRequestId: String
	userEmail: String
	userProfileUrl: String
	violationCount: String
	wrapUpCode: String
	chatAcceptTimeStamp: String
}

input UpdateConversationInput {
	conversationId: ID!
	endTimestamp: String
}

input UpdateCustomerMemo {
	content: String!
	mdn: ID!
	updatedAt: String
	updatedBy: String
}

input UpdateMessageInput {
	isActive: Boolean
	isSent: Boolean
	messageId: ID!
	messageStatus: String
}

input UpdateUserMessageResponseTimeInput {
	messageId: ID!
	userResponseTime: String
}

input UpdateVideoRequest {
	expertId: String
	expertName: String
	requestId: String!
	roomId: String
	status: String
	wrapUpCode: String
	answeredTimestamp: Float
	acwTimestamp: Float
}

input UpdateVisitorInput {
	imei: String
	journeyStatus: String
	mdn: String
	userName: String
	policyNumber: String
	ipAddress: String
	visitorId: ID!
	interactionType: String
	carrierName: String
	lastUpdatedTime: String
	chatAssisted: String
	lastActivity: String
	caseNumber: String
	interactionId: ID
	perilType: String
	chatReason: String
}

input UpdateVisitorTypingInput {
	conversationId: ID!
	visitorTyping: Boolean!
}

input UpdateVoiceRequest {
	answeredTimestamp: Float
	timeToAnswer: Float
	requestId: String!
	endTimestamp: Float
	callDuration: Float
	status: String
	chatRequestId: String
	conversationId: String
}

type VideoAudit @aws_api_key
@aws_cognito_user_pools
@aws_iam {
	auditLog: String!
	videoAuditId: ID!
	createdAt: String!
	expertName: String
	requestId: ID!
	visitorId: ID!
}

type VideoRequest @aws_api_key
@aws_cognito_user_pools
@aws_iam {
	carrier: String
	endTimestamp: String
	enrollmentStatus: String
	expertId: String
	expertName: String
	mdn: String
	requestId: String!
	roomId: String
	startTimestamp: String
	taskId: String!
	visitorId: String
	wrapUpCode: String
	rating: Int
	agreementId: String
	memo: String
	expertToken: String
	compositionId: String
	clientToken: String
	chatRequestId: String
	status: String
}

input VideoSearchParams {
	carrier: String
	endTimestamp: String!
	wrapUpCode: String
	mdn: String
	startTimestamp: String!
	expertId: String
}

type Visitor {
	authenticationStatus: Boolean
	browserAgent: String
	clientId: String
	imei: String
	interactionId: ID
	ipAddress: String
	journeyStatus: String
	languageCode: String
	mdn: String
	policyNumber: String
	startTimestamp: String
	userName: String
	visitorCognitoId: ID
	visitorId: String!
	source: String
	interactionType: String
	carrierName: String
	lastUpdatedTime: String
	chatAssisted: String
	lastActivity: String
	caseNumber: String
	perilType: String
	chatReason: String
}

type VoiceAudit @aws_api_key
@aws_cognito_user_pools
@aws_iam {
	voiceAuditId: String!
	auditLog: String!
	createdAt: String!
	requestId: String!
}

type VoiceRequest @aws_api_key
@aws_cognito_user_pools
@aws_iam {
	carrier: String
	endTimestamp: String
	expertId: String
	expertName: String
	destination: String
	requestId: String!
	source: String
	startTimestamp: String
	answeredTimestamp: String
	visitorId: String
	status: String
	callDuration: String
	timeToAnswer: String
	chatRequestId: String
	conversationId: String
	expertPhoto: String
	type: String
}

type VoiceRequestPaginated @aws_api_key
@aws_cognito_user_pools
@aws_iam {
	items: [VoiceRequest]
	nextToken: String
}

input VoiceSearchParams {
	carrier: String
	endTimestamp: String!
	status: String
	mdn: String
	startTimestamp: String!
	expertId: String
	expertName: String
	chatRequestId: String
}

schema {
	query: Query
	mutation: Mutation
	subscription: Subscription
}
    EOF
    tags = {
	NAME              = "${var.project_name}-shared-online-appsync-${var.tag_environment}-${var.env_version}"
    BUSINESS_REGION   = "${var.tag_business_region}"
    BUSINESS_UNIT     = "${var.tag_business_unit}"
    CLIENT            = "${var.tag_client}"
    ENVIRONMENT       = "${var.tag_environment}"
    PLATFORM          = "${var.tag_platform}"
    ResourceCreatedBy = "${var.tag_resource_created_by}"
    EMAIL_DISTRIBUTION = "${var.tag_email_distribution}"
  }
}
