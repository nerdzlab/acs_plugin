//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit
import SwiftUI

enum CompositeIcon: String {
    case none = ""
    case cameraSwitch = "ic_fluent_camera_switch_24_regular"
    case backgroundEffectOn = "ic_background_effect_on"
    case backgroundEffectOff = "ic_background_effect_off"
    case meetNow = "ic_fluent_meet_now_20_regular"
    case micOff = "ic_fluent_mic_off_24_filled"
    case micOffRegular = "ic_fluent_mic_off_24_regular"
    case micOn = "ic_fluent_mic_24_filled"
    case micOnRegular = "ic_fluent_mic_24_regular"
    case speakerFilled = "ic_fluent_speaker_2_24_filled"
    case speakerRegular = "ic_fluent_speaker_2_24_regular"
    case speakerBluetooth = "ic_fluent_speaker_bluetooth_24_regular"
    case videoOn = "ic_fluent_video_24_filled"
    case videoOff = "ic_fluent_video_off_24_filled"
    case videoOffRegular = "ic_fluent_video_off_24_regular"
    case warning = "ic_fluent_warning_24_filled"
    case endCall = "ic_fluent_call_end_24_filled"
    case endCallRegular = "ic_fluent_call_end_24_regular"
    case showParticipant = "ic_fluent_people_24_regular"
    case addParticipant = "ic_fluent_guest_add_20_filled"
    case lobbyError = "ic_fluent_person_prohibited_24_regular"
    case leftArrow = "ic_ios_arrow_left_24"
    case callClose = "call_close"
    case volumeOff = "ic_ios_volume_off"
    case dismiss = "ic_fluent_dismiss_16_regular"
    case whiteClose = "white_close"
    case clock = "ic_fluent_clock_24_filled"
    case checkmark = "ic_fluent_checkmark_24_regular"
    case share = "ic_fluent_share_ios_24_regular"
    case more = "ic_fluent_more_horizontal_24_filled"
    case wifiWarning = "ic_fluent_wifi_warning_24_filled"
    case speakerMute = "ic_fluent_speaker_mute_24_regular"
    case micProhibited = "ic_fluent_mic_prohibited_24_regular"
    case personFeedback = "ic_fluent_person_feedback_24_regular"
    case rightChevron = "ic_fluent_chevron_right_20_regular"
    case closeCaptions = "ic_fluent_closed_caption_24_regular"
    case localLanguage = "ic_fluent_local_language_24_regular"
    case personVoice = "ic_fluent_person_voice_24_regular"
    case personDelete = "ic_fluent_person_delete_24_regular"
    case captionsError = "ic_fluent_error_circle_16_regular"
    case noiseSuppresion = "noise_suppresion"
    case switchCameraFilled = "filled_switch_camera"
    case chatIcon = "chat_icon"
    case pinIcon = "pin_icon"
    case unpinIcon = "unpin_icon"
    case shareIcon = "share_icon"
    case stopShareIcon = "stop_share_icon"
    case speakerIcon = "speaker_icon"
    case gridIcon = "grid_icon"
    case handUp = "hand_up"
    case handDown = "hand_down"
    case pinInfo = "pin_info"
    case backgroundOne = "background_1"
    case backgroundTwo = "background_2"
    case backgroundThree = "background_3"
    case backgroundFour = "background_4"
    case backgroundFive = "background_5"
    case backgroundSix = "background_6"
    case checkmarkEffects = "checkmark"
    case closeEffects = "close_effects"
    case blurBackground = "blur_background"
    case noneBackground = "none_background"
}

struct IconProvider {
    func getUIImage(for iconName: CompositeIcon) -> UIImage? {
        UIImage(named: "Icon/\(iconName.rawValue)",
                in: Bundle(for: CallComposite.self),
                compatibleWith: nil)
    }
    
    func getImage(for iconName: CompositeIcon) -> Image {
        Image("Icon/\(iconName.rawValue)", bundle: Bundle(for: CallComposite.self))
            .resizable()
            .renderingMode(.template)
    }
}

struct ImageProvider {
    func getImage(for imageName: CompositeIcon) -> Image {
        Image("Icon/\(imageName.rawValue)",
              bundle: Bundle(for: CallComposite.self))
            .resizable()
    }
    
    func getUIImage(for iconName: CompositeIcon) -> UIImage? {
        UIImage(named: "Icon/\(iconName.rawValue)",
                in: Bundle(for: CallComposite.self),
                compatibleWith: nil)
    }
}
