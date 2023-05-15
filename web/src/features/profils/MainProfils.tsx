import React, { useState } from 'react';
import { fetchNui } from '../../utils/fetchNui';
import {
  Text,
  //Aside,
  AppShell,
  Navbar,
  //Header,
  Group,
  //Footer,
  Skeleton,
  UnstyledButton,
  Box,
  useMantineTheme,
  rem,
  Container, Modal, TextInput, Button, Stack,
} from '@mantine/core';
import { DateInput } from '@mantine/dates';
//import { useConfig } from '../../providers/ConfigProvider';
import { useNuiEvent } from '../../hooks/useNuiEvent';
import { User, UserProps, CharsList, CharListProps } from './components';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import { faPlus } from '@fortawesome/free-solid-svg-icons';;
//import { debugData } from '../../utils/debugData';

interface LoadProfilsProps {
  username: string;
  permission: string;
  logo: string;
  submit?: string; // Using to close menu in dev environment
  chars?: CharListProps[];
}

interface DataPropsIdentity {
  firstName: string;
  lastName: string;
  dateOfBirth: string;
}

interface NewCharModalProps {
    title: string;
}

const NewCharModal = () => {
  const [formData, setFormData] = useState<DataPropsIdentity>({
    firstName: '',
    lastName: '',
    dateOfBirth: '',
  });

  const handleSubmit = async (type: any) => {
    if (!type) return;
    await new Promise((resolve) => setTimeout(resolve, 200));
    //fetchNui('sl:modal:closedCustom');
  };

  
  const handleInputChange = (name: 'firstName' | 'lastName' | 'dateOfBirth', value: string) => {
    setFormData((prevData) => {
      const updatedData = { ...prevData };
      updatedData[name] = value;
      return updatedData;
    });
  };

  const formatDate = (date: Date | null): string => {
    return date
      ? date.toLocaleDateString('fr-FR', {
          day: '2-digit',
          month: '2-digit',
          year: 'numeric',
        })
      : '';
  };

  const onPlaceHolder = (date: Date | null): string => {
    return date
      ? formatDate(date)
      : new Date().toLocaleDateString('fr-FR', {
          day: '2-digit',
          month: '2-digit',
          year: 'numeric',
        });
  };

  //setFormData({ ...formData, dateOfBirth: onPlaceHolder(new Date())})
  return (
    <>
      <Modal
        opened={true}
        onClose={() => handleSubmit(false)}
        title='Nouveau personnage'
        size='xs'
        centered
        withCloseButton={false}
      >
        <Stack spacing='md'>
          <TextInput
            label='First Name'
            placeholder='John'
            required
            onChange={(event) =>
              handleInputChange('firstName', event.currentTarget.value)
            }
          />
          <TextInput
            label='Last Name'
            placeholder='Doe'
            required
            onChange={(event) =>
              handleInputChange('lastName', event.currentTarget.value)
            }
          />
          <DateInput
            value={new Date()}
            onChange={(event) =>
              console.log(event)
            }
            label='Date input'
            placeholder={formData.dateOfBirth}
            valueFormat='DD/MM/YYYY'
            maw={400}
            mx='auto'
          />
        </Stack>
        <Group position='right'></Group>
      </Modal>
    </>
  );
};

export const MainProfilesMenu: React.FC = () => {
  const theme = useMantineTheme();
  const [data, setData] = useState<UserProps>({ username: '', permission: '' });
  const [chars, setChars] = useState<CharListProps[]>([]);
  const [opened, setOpened] = useState(false);

  useNuiEvent<LoadProfilsProps>('sl:profiles:opened', (Data) => {
    if (Data.submit === 'disconnect' && opened) return setOpened(false); // This is to close the menu when dev Env
    const user = Data.username;
    const permission = Data.permission;
    if (!user || !permission) return;
    setData({ username: user, permission: permission, logo: Data.logo });
    setChars(Data.chars || []);
    setOpened(true);
  });

  useNuiEvent<{key: string, value: string | CharListProps[]}>('sl:update:profile', (Data) => {
    switch (Data.key) {
      case 'username':
        setData({ ...data, username: Data.value as string});
        break;
      case 'characters':
        setChars(Data.value as CharListProps[]);
        break;
      default: break;
    }
  });

  const handleSubmit = async () => {
    await new Promise((resolve) => setTimeout(resolve, 200));
    fetchNui('sl:profiles:onSubmit', {submit: 'newChar'});
  };

  return (
    <Container>
      <AppShell
        styles={{
          main: {
            display: 'flex',
            //margin: 20
          },
        }}
        hidden={!opened}
        navbarOffsetBreakpoint='sm'
        asideOffsetBreakpoint='sm'
        navbar={
          <Navbar
            p='md'
            hiddenBreakpoint='sm'
            width={{ sm: 200, lg: 300 }}
            //style={{ margin: 20}}
          >
            <Navbar.Section grow mt='xs'>
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
                {chars.map((char, index) => (
                  <CharsList chars={char} index={index} />
                ))}
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
                    borderTop: `${rem(1)} solid ${
                      theme.colorScheme === 'dark'
                        ? theme.colors.teal[6]
                        : theme.colors.gray[2]
                    }`,

                    '&:hover': {
                      backgroundColor:
                        theme.colorScheme === 'dark'
                          ? theme.colors.teal[6]
                          : theme.colors.gray[0],
                      opacity: 0.75,
                    },
                  }}
                >
                  <Group>
                    <Skeleton height={45} circle mb='xs' />
                    <Box sx={{ flex: 1 }} onClick={handleSubmit}>
                      <Text color='dimmed' size='xs'>
                        Add a new character
                      </Text>
                    </Box>
                    <FontAwesomeIcon
                      icon={faPlus}
                      style={{ bottom: 0, right: 0 }}
                    />
                  </Group>
                </UnstyledButton>
              </Box>
            </Navbar.Section>
            <Navbar.Section>
              {/*Profile Settings*/}
              <User
                username={data.username || 'SUP2Ak The BG issous'}
                permission={data.permission || 'Player'}
                logo={data.logo}
              />
            </Navbar.Section>
          </Navbar>
        }
      >
        {/*Main compoenent to add char 3d view + stats rect*/}
        <Text color='black'>Main View 3D char + Stats of Char + Cam button</Text>
      </AppShell>
    </Container>
  );
};
