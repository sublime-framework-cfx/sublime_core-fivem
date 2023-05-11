import React from 'react';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import { faChevronUp, faChevronLeft, faPersonWalkingDashedLineArrowRight, faUserPen, faIdBadge } from '@fortawesome/free-solid-svg-icons';
import { UnstyledButton, Group, Avatar, Text, Box, useMantineTheme, rem, Menu, TextInput, Button } from '@mantine/core';

export interface UserProps {
    username: string;
    permission: string;
    logo?: string;
}

export const User: React.FC<UserProps> = ({ username, permission, logo }) => {
    const theme = useMantineTheme();
    const [opened, setOpened] = React.useState(false);
    const handleToggle = () => setOpened((opened) => !opened);
    const [newLogo, setNewLogo] = React.useState(logo);
    const [set, Set] = React.useState<boolean>(false);

    return (
        <>
            <Menu opened={opened} position='top-end' closeOnClickOutside onClose={() => setOpened(false)}>
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
                                src={newLogo}
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
                    <Menu.Item onClick={() => Set(true)} icon={<FontAwesomeIcon icon={faIdBadge} />} color={theme.colors.teal[6]}>Changer avatar</Menu.Item>
                    <Menu.Item icon={<FontAwesomeIcon icon={faPersonWalkingDashedLineArrowRight} />} color='red'>Se deconnecter</Menu.Item>
                </Menu.Dropdown>
            </Menu>
            { set && (
                <Group>
                    <TextInput
                        label="URL de l'image"
                        value={newLogo}
                        onChange={(event) =>
                            setNewLogo(event.currentTarget.value.length > 10 ? event.currentTarget.value : newLogo)
                        }
                        placeholder="Copier ici l'URL de l'image..."
                    />
                    <Button onClick={() => Set(false)} color='teal'>Valider</Button>
                </Group>
            )}
        </>
    );
}