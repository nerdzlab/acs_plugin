package com.acs_plugin.chat.redux.action

import com.acs_plugin.chat.models.ParticipantTimestampInfoModel
import com.acs_plugin.chat.models.RemoteParticipantInfoModel

internal sealed class ParticipantAction : Action {
    class ParticipantsAdded(val participants: List<RemoteParticipantInfoModel>) :
        ParticipantAction()

    class ParticipantsRemoved(val participants: List<RemoteParticipantInfoModel>) :
        ParticipantAction()
    class AddParticipantTyping(val infoModel: ParticipantTimestampInfoModel) : ParticipantAction()
    class RemoveParticipantTyping(val infoModel: ParticipantTimestampInfoModel) :
        ParticipantAction()

    class ReadReceiptReceived(val infoModel: ParticipantTimestampInfoModel) : ParticipantAction()
    class ParticipantToHideReceived(val id: String) : ParticipantAction()
}
