import React, { useState } from 'react';
import {
  Modal,
  TextInput,
  PasswordInput,
  Group,
  Stack,
  Text,
} from '@mantine/core';
import AnimatedButton from '../modal/components/buttons';
import { faCheck, faXmark, faLock, faUserShield } from '@fortawesome/free-solid-svg-icons';
import { useNuiEvent } from '../../hooks/useNuiEvent';
import { fetchNui } from '../../utils/fetchNui';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';

export const Login: React.FC = () => {
  const [username, setUsername] = useState<string>('');
  const [password, setPassword] = useState<string>('');
  const [showModal, setShowModal] = useState<boolean>(false);
  const [onForgot, setForgot] = useState<boolean>(false);

  const areRequiredFieldsCompleted =
    username.length << 1 && password.length << 1;

  useNuiEvent('sl:login:opened', () => {
    setShowModal(true);
  });

  const handleSubmit = async (forgot?: boolean) => {
    await new Promise((resolve) => setTimeout(resolve, 200));
    if (forgot) {
      fetchNui('sl:login:submit', false);
    } else {
      setShowModal(false);
      fetchNui('sl:login:submit', { username, password });
    }
  };

  return (
    <>
      <Modal
        opened={showModal}
        centered
        onClose={() => handleSubmit}
        title='Login'
        size='xs'
        withCloseButton={false}
        padding='xs'
      >
        <Stack>
          <TextInput
            label='Username'
            withAsterisk
            placeholder='Your username'
            onChange={(event) => setUsername(event.target.value)}
            icon={<FontAwesomeIcon icon={faUserShield} size='xs' fade />}
          />
          <PasswordInput
            withAsterisk
            label='Password'
            placeholder='Your password'
            onChange={(event) => setPassword(event.target.value)}
            icon={<FontAwesomeIcon icon={faLock} size='xs' fade />}
          />
          <Text
            c='dimmed'
            td='underline'
            size='sm'
            {...(onForgot
              ? {
                  style: { color: 'white', cursor: 'help' },
                  onMouseLeave: () => setForgot(false),
                  onClick: () => handleSubmit(true),
                }
              : {
                  style: { color: 'gray' },
                  onMouseEnter: () => setForgot(true),
                }
              )
            }
          >
            Mot de passe oublié?
          </Text>
        </Stack>
        <Group position='right' pt={10}>
          <AnimatedButton
            iconAwesome={faXmark}
            text='Annuler'
            onClick={handleSubmit}
            color='red'
            args={false}
          />
          <AnimatedButton
            iconAwesome={faCheck}
            text='Valider'
            onClick={handleSubmit}
            color='green'
            args={true}
            isDisabled={!areRequiredFieldsCompleted}
          />
        </Group>
      </Modal>
    </>
  );
};