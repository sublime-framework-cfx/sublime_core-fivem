import React, { useState } from 'react';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import {
  faChevronUp,
  faChevronLeft,
  faPersonWalkingDashedLineArrowRight,
  faUserPen,
  faIdBadge,
} from '@fortawesome/free-solid-svg-icons';
import {
  UnstyledButton,
  Group,
  Avatar,
  Text,
  Box,
  useMantineTheme,
  rem,
  Menu,
  TextInput,
  Button,
} from '@mantine/core';
import { firstToUpper } from '../../../function';
import { fetchNui } from '../../../utils/fetchNui';
import AnimatedButton from '../../modal/components/buttons';
import { debugData } from '../../../utils/debugData';

export interface UserProps {
  username: string;
  permission: string;
  logo?: string;
}

export const User: React.FC<UserProps> = ({ username, permission, logo }) => {
  const theme = useMantineTheme();
  const [opened, setOpened] = useState(false);
  const handleToggle = () => setOpened((opened) => !opened);
  const [newLogo, setNewLogo] = useState(logo);
  const [set, Set] = useState<boolean>(false);

  const handleSet = async (key: string, value: any) => {
    await new Promise((resolve) => setTimeout(resolve, 200));
    fetchNui('sl:profiles:onEdit', { edit: 'profile', key: key, value: value });
  };

  const handlerDisconnected = async () => {
    await new Promise((resolve) => setTimeout(resolve, 200));
    setOpened(false);
    fetchNui(
      'sl:profiles:onSubmit',
      { submit: 'disconnect', value: true },
      debugData([
        {
          action: 'sl:profiles:opened',
          data: {
            username: 'uknown',
            permission: 'none',
            submit: 'disconnect',
          },
        },
      ])
    );
  };

  return (
    <>
      <Menu
        opened={opened}
        position='top-end'
        closeOnClickOutside
        onClose={() => setOpened(false)}
      >
        <Box
          sx={{
            paddingTop: theme.spacing.sm,
            borderTop: `${rem(1)} solid ${
              theme.colorScheme === 'dark'
                ? theme.colors.teal[6]
                : theme.colors.gray[2]
            }`,
          }}
        >
          <Menu.Target>
            <UnstyledButton
              sx={{
                display: 'block',
                width: '100%',
                padding: theme.spacing.xs,
                borderRadius: theme.radius.sm,
                color:
                  theme.colorScheme === 'dark'
                    ? theme.colors.dark[0]
                    : theme.black,

                '&:hover': {
                  backgroundColor:
                    theme.colorScheme === 'dark'
                      ? theme.colors.teal[6]
                      : theme.colors.gray[0],
                  opacity: 0.75,
                },
              }}
              onClick={handleToggle}
            >
              <Group>
                <Avatar src={newLogo} radius='xl' />
                <Box sx={{ flex: 1 }}>
                  <Text size='sm' weight={500} color='white'>
                    {username}
                  </Text>
                  <Text color='dimmed' size='xs'>
                    {firstToUpper(permission)}
                  </Text>
                </Box>
                {!opened ? (
                  <FontAwesomeIcon icon={faChevronLeft} />
                ) : (
                  <FontAwesomeIcon icon={faChevronUp} />
                )}
              </Group>
            </UnstyledButton>
          </Menu.Target>
        </Box>
        <Menu.Dropdown>
          <Menu.Item
            icon={<FontAwesomeIcon icon={faUserPen} />}
            disabled={permission !== 'owner'}
            onClick={() => handleSet('username', true)}
          >
            {' '}
            {/* NEED CHECKER PERMISSION NUI PROVIDER !!!! */}
            Changer son nom
          </Menu.Item>
          <Menu.Item
            icon={<FontAwesomeIcon icon={faUserPen} />}
            disabled={permission !== 'owner'}
            onClick={() => handleSet('password', true)}
          >
            {' '}
            {/* NEED CHECKER PERMISSION NUI PROVIDER !!!! */}
            Changer son mot de passe
          </Menu.Item>
          <Menu.Item
            onClick={() => Set(true)}
            icon={<FontAwesomeIcon icon={faIdBadge} />}
            color={theme.colors.teal[6]}
          >
            Changer avatar
          </Menu.Item>
          <Menu.Item
            icon={
              <FontAwesomeIcon icon={faPersonWalkingDashedLineArrowRight} />
            }
            color='red'
            onClick={() => handlerDisconnected()}
          >
            Se deconnecter
          </Menu.Item>
        </Menu.Dropdown>
      </Menu>
      {set && (
        <Group>
          <TextInput
            label="URL de l'image"
            value={newLogo}
            onChange={(event) =>
              setNewLogo(
                event.currentTarget.value.length > 10
                  ? event.currentTarget.value
                  : newLogo
              )
            }
            placeholder="Copier ici l'URL de l'image..."
          />
          <Button
            onClick={() => {
              Set(false);
              handleSet('logo', newLogo);
            }}
            color='teal'
          >
            Valider
          </Button>
        </Group>
      )}
    </>
  );
};
