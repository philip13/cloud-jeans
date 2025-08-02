-- Trigger para nuevos mensajes
CREATE OR REPLACE FUNCTION update_conversation_status()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO conversation_statuses (session_id, status, last_message, last_message_at, created_at, updated_at)
  VALUES (NEW.session_id, 'unread', NEW.message->>'text', NOW(), NOW(), NOW())
  ON CONFLICT (session_id)
  DO UPDATE SET
    status = 'unread',
    last_message = EXCLUDED.last_message,
    last_message_at = EXCLUDED.last_message_at,
    updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Crear el trigger
CREATE TRIGGER sync_conversation_status
AFTER INSERT ON n8n_chat_histories
FOR EACH ROW
EXECUTE FUNCTION update_conversation_status();


-- Trigger para nuevos mensajes V1.1 TODO: Competlar antes de usar en produccion


BEGIN
  INSERT INTO conversation_statuses (session_id, status, last_message, last_message_at, created_at, updated_at)
  VALUES (
  	NEW.session_id,
	'unread',
	NEW.message->>'content',  -- Extrae el campo 'content' del JSON
	NOW(),
	NOW(), 
	NOW()
  )
  ON CONFLICT (session_id)
  DO UPDATE SET
    status = 'unread',
    last_message = EXCLUDED.last_message,
    last_message_at = EXCLUDED.last_message_at,
    updated_at = NOW();
  RETURN NEW;
END;
