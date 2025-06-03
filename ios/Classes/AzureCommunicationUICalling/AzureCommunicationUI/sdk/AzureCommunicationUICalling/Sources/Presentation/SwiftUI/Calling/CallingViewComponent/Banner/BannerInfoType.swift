//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

enum BannerInfoType: Equatable {
    case recordingAndTranscriptionStarted
    case recordingStarted
    case transcriptionStoppedStillRecording
    case transcriptionStarted
    case transcriptionStoppedAndSaved
    case recordingStoppedStillTranscribing
    case recordingStopped
    case recordingAndTranscriptionStopped
    
    var title: LocalizationKey {
        switch self {
        case .recordingAndTranscriptionStarted:
            return .bannerTitleRecordingAndTranscriptionStarted
        case .recordingStarted:
            return .bannerTitleReordingStarted
        case .transcriptionStoppedStillRecording:
            return .bannerTitleTranscriptionStoppedStillRecording
        case .transcriptionStarted:
            return .bannerTitleTranscriptionStarted
        case .transcriptionStoppedAndSaved:
            return .bannerTitleTranscriptionStopped
        case .recordingStoppedStillTranscribing:
            return .bannerTitleRecordingStoppedStillTranscribing
        case .recordingStopped:
            return .bannerTitleRecordingStoppedStillTranscribing
        case .recordingAndTranscriptionStopped:
            return .bannerTitleRecordingAndTranscribingStopped
        }
    }
    
    var body: LocalizationKey {
        switch self {
        case .transcriptionStarted:
            return .bannerBodyConsent
        case .transcriptionStoppedStillRecording:
            return .bannerBodyRecording
        case .transcriptionStoppedAndSaved:
            return .bannerBodyTranscriptionStopped
        case .recordingStoppedStillTranscribing:
            return .bannerBodyOnlyTranscribing
        case .recordingAndTranscriptionStopped:
            return .bannerBodyRecordingAndTranscriptionStopped
        case .recordingAndTranscriptionStarted,
                .recordingStarted,
                .recordingStopped:
            return .emptyString
        }
    }
    
    var linkDisplay: LocalizationKey {
        switch self {
        case .transcriptionStoppedStillRecording,
                .transcriptionStarted:
            return .bannerDisplayLinkPrivacyPolicy
        case .transcriptionStoppedAndSaved:
            return .bannerDisplayLinkLearnMore
        case .recordingAndTranscriptionStarted,
                .recordingStarted,
                .recordingStoppedStillTranscribing,
                .recordingStopped,
                .recordingAndTranscriptionStopped:
            return .emptyString
        }
    }
    
    var link: String {
        switch self {
        case .transcriptionStoppedStillRecording,
                .transcriptionStarted:
            return StringConstants.privacyPolicyLink
        case .transcriptionStoppedAndSaved:
            return StringConstants.learnMoreLink
        case .recordingAndTranscriptionStarted,
                .recordingStarted,
                .recordingStoppedStillTranscribing,
                .recordingStopped,
                .recordingAndTranscriptionStopped:
            return ""
        }
    }
}
