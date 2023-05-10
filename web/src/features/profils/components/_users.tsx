import React from 'react';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import { faChevronUp, faChevronLeft, faPersonWalkingDashedLineArrowRight, faUserPen, faIdBadge } from '@fortawesome/free-solid-svg-icons';
import { UnstyledButton, Group, Avatar, Text, Box, useMantineTheme, rem, Menu } from '@mantine/core';
import style from 'react-syntax-highlighter/dist/esm/styles/hljs/a11y-dark';

export interface UserProps {
    username: string;
    permission: string;
    logo?: string;
}

export const User: React.FC<UserProps> = ({ username, permission, logo }) => {
    const theme = useMantineTheme();
    const [opened, setOpened] = React.useState(false);
    const handleToggle = () => setOpened((opened) => !opened);

    return (
        <Menu opened={opened} position='top-end' closeOnClickOutside onClose={handleToggle}>
            <Box
                sx={{
                    paddingTop: theme.spacing.sm,
                    borderTop: `${rem(1)} solid ${theme.colorScheme === 'dark' ? theme.colors.teal[6] : theme.colors.gray[2]}`,
                }}
            >
                <UnstyledButton
                    sx={{
                        display: 'block',
                        width: '100%',
                        padding: theme.spacing.xs,
                        borderRadius: theme.radius.sm,
                        color: theme.colorScheme === 'dark' ? theme.colors.dark[0] : theme.black,

                        '&:hover': {
                            backgroundColor: theme.colorScheme === 'dark' ? theme.colors.teal[6] : theme.colors.gray[0],
                            opacity: 0.75,  
                        },
                    }}
                    onClick={handleToggle}
                >
                    <Group>
                        <Avatar
                            src={logo}
                            radius="xl"
                        />
                        <Box sx={{ flex: 1 }}>
                            <Text size="sm" weight={500} color='white'>
                                {username}
                            </Text>
                            <Text color="dimmed" size="xs">
                                {permission}
                            </Text>
                        </Box>
                        {!opened ? (
                            <FontAwesomeIcon icon={faChevronLeft} />
                        ) : (
                            <Menu.Target>
                                <FontAwesomeIcon icon={faChevronUp} />
                            </Menu.Target>                          
                        )}
                    </Group>
                </UnstyledButton>   
            </Box>
            <Menu.Dropdown>
                <Menu.Item icon={<FontAwesomeIcon icon={faUserPen} />} disabled>Changer son nom</Menu.Item>
                <Menu.Item icon={<FontAwesomeIcon icon={faUserPen} />} disabled>Changer son mot de passe</Menu.Item>
                <Menu.Item icon={<FontAwesomeIcon icon={faIdBadge} />} color={theme.colors.teal[6]}>Changer avatar</Menu.Item>
                <Menu.Item icon={<FontAwesomeIcon icon={faPersonWalkingDashedLineArrowRight} />} color='red'>Se deconnecter</Menu.Item>
            </Menu.Dropdown>
        </Menu>
    );
}