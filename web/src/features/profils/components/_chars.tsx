import React from 'react';
import { UnstyledButton, Box, Group, useMantineTheme, rem, Avatar, Skeleton, Text } from '@mantine/core';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import { faPlus } from '@fortawesome/free-solid-svg-icons';


interface CharListProps {
    chars: Array<string[]>;
}

export const CharsList: React.FC<CharListProps> = ({chars}) => {
    const theme = useMantineTheme();

    return (
        <Box
            sx={{
                paddingTop: theme.spacing.sm,
                borderTop: `${rem(1)} solid ${theme.colorScheme === 'dark' ? theme.colors.teal[6] : theme.colors.gray[2]}`,
            }}
        >
            { // soon to be replaced by a map
                chars.map((char, index) => (
                    <UnstyledButton>

                    </UnstyledButton>
                ))
                
            }
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
                //onClick={handleToggle} Add Char function later
            >
                <Group>
                    <Skeleton height={45} circle mb="xs" />
                    <Box sx={{ flex: 1 }}>
                        <Text color="dimmed" size="xs">
                            Add a new character
                        </Text>
                    </Box>
                    <FontAwesomeIcon icon={faPlus} style={{bottom: 0, right: 0}}/> 
                </Group>
                
            </UnstyledButton>
        </Box>
    );
};