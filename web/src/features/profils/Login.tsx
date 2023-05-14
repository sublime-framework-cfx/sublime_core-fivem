import React, { useState } from 'react';
import {
  Modal,
  TextInput,
  PasswordInput,
  Group,
  Stack,
  Text,
  Checkbox
} from '@mantine/core';
import AnimatedButton from '../modal/components/buttons';
import { faCheck, faLock, faUserShield } from '@fortawesome/free-solid-svg-icons';
import { useNuiEvent } from '../../hooks/useNuiEvent';
import { fetchNui } from '../../utils/fetchNui';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import { debugData } from '../../utils/debugData';

export const Login: React.FC = () => {
  const [username, setUsername] = useState<string>('');
  const [password, setPassword] = useState<string>('');
  const [saveKvp, setSaveKvp] = useState<boolean>(false);
  const [showModal, setShowModal] = useState<boolean>(false);
  const [onForgot, setForgot] = useState<boolean>(false);

  const areRequiredFieldsCompleted = username.length << 1 && password.length << 1;

  useNuiEvent<{username: string, password: string, saveKvp: boolean}>('sl:login:opened', async (data?) => {
    if (data) {
      setUsername(data?.username);
      setPassword(data?.password);
      setSaveKvp(data?.saveKvp);
    }
    await new Promise((resolve) => setTimeout(resolve, 200));
    setShowModal(true);
  });

  const handleSubmit = async () => {
    await new Promise((resolve) => setTimeout(resolve, 200));
    if (onForgot) {
      fetchNui('sl:login:submit', false);
    } else {
      setShowModal(false);
      fetchNui('sl:login:submit', { username, password, saveKvp }, debugData(
        [{
          action: 'sl:profiles:opened',
          data: {username: 'SUP2Ak', permission: 'god', chars: [
            { firstname: 'Jean', lastname: 'Michel', dob: '11/02/1986', sex: 'H' },
            { firstname: 'Thérèse', lastname: 'Marie', dob: '12/12/2000', sex: 'F' },
          ]},
        }]
      ));
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
        transitionProps={{
          transition: 'scale-y',
          duration: 250,
          keepMounted: true,
          timingFunction: 'ease-in-out',
        }}
      >
        <Stack>
          <TextInput
            label='Username'
            withAsterisk
            placeholder='Your username'
            value={username}
            onChange={(event) => setUsername(event.target.value)}
            icon={<FontAwesomeIcon icon={faUserShield} size='xs' fade />}
          />
          <PasswordInput
            withAsterisk
            label='Password'
            value={password}
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
                  onClick: () => handleSubmit(),
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
        <Group pt={10}>
          <AnimatedButton
            iconAwesome={faCheck}
            text='Valider'
            onClick={handleSubmit}
            color='green'
            args={true}
            isDisabled={!areRequiredFieldsCompleted}
          />
          <Checkbox
            label='Se souvenir de moi?'
            color='teal.6'
            checked={saveKvp}
            onChange={(event) => setSaveKvp(event.currentTarget.checked)}
            style={{marginLeft: 2}}
          />
        </Group>
      </Modal>
    </>
  );
};