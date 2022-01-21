def apply_or_cancel_button(current_user)
  if entry = object.entries.find_by(user_id: current_user.id)
    status = cancellation_status(entry)
    h.button_to cancel_button_label_text(status),
                [:cancel,:customer,object,:entry],
                disabled: status != :cancellable,method: :patch,
                data: {confirm: "本当にキャンセルしますか？ "}
  else
    status = program_status
    h.button_to button_label_text(status),
                disabled: status != :available,method: :post,
                data: {confirm: "本当に申し込みますか？ "}
  end
end

def program_status
  if object.application_end_time.try(:<,Time.current)
    :closed
  elsif object.max_number_of_participants.try(:<=,object.application.count)
    :full
  else
    :available
  end
end

def cancellation_status(entry)
  if object.application_end_time.try(:<,Time.current)
    :closed
  elsif entry.canceled?
    :canceled
  else
    :cancellable
  end
end

def button_label_text(status)
  case status
  when :closed
    '募集終了'
  when :full
    '満員'
  else
    '申し込む'
  end
end

def cancel_button_label_text(status)
  case status
  when :closed
    '申し込み済み（キャンセル不可）'
  when :canceled
    'キャンセル済み'
  else
    'キャンセルする'
  end
end
