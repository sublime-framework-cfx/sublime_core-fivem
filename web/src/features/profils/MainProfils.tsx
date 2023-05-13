import React, { useState } from 'react';
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
  Container
} from '@mantine/core';
import { useConfig } from '../../providers/ConfigProvider';
import { useNuiEvent } from '../../hooks/useNuiEvent';
import { User, UserProps, CharsList, CharListProps } from './components';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import { faPlus } from '@fortawesome/free-solid-svg-icons';

// dev
const characters: CharListProps[] = [
  { firstname: 'Jean', lastname: 'Michel', dob: '11/02/1986', sex: 'H' },
  { firstname: 'Thérèse', lastname: 'Marie', dob: '12/12/2000', sex: 'F' },
];

interface LoadProfilsProps {
  username: string;
  permission: string;
  logo: string;
  chars?: CharListProps[];
}

export const MainProfilesMenu: React.FC = () => {
  const theme = useMantineTheme();
  const [data, setData] = useState<UserProps>({ username: '', permission: '' });
  const [chars, setChars] = useState<CharListProps[]>([]);
  const [opened, setOpened] = useState(false); // on true per default during dev

  useNuiEvent<LoadProfilsProps>('sl:profiles:opened', (data) => {
    const user = data.username;
    const permission = data.permission;
    if (!user || !permission) return;
    setData({ username: user, permission: permission });
    setChars(data.chars || []);
    setOpened(true);
  });


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
                    <Box sx={{ flex: 1 }}>
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
                username={data.username || 'SUP2Ak'}
                permission={data.permission || 'Player'}
                logo={
                  data.logo ||
                  'https://avatars.githubusercontent.com/u/31973315?v=4'
                }
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
