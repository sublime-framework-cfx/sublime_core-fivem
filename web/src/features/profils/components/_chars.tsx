import React from 'react';
import { UnstyledButton, Box, Group, useMantineTheme, rem, Avatar, Skeleton, Text } from '@mantine/core';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import { faChevronRight } from '@fortawesome/free-solid-svg-icons';

export interface CharListProps {
    firstname: string;
    lastname: string;
    age: number;
    sex: string;
}

interface InCharListProps {
    chars: CharListProps;
    index: number;
}

export const CharsList: React.FC<InCharListProps> = ({chars, index}) => {
    const theme = useMantineTheme();
    return (
        <Box
            sx={{
                paddingTop: theme.spacing.sm,
                //borderTop: `${rem(1)} solid ${theme.colorScheme === 'dark' ? theme.colors.teal[6] : theme.colors.gray[2]}`,
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
                //onClick={handleToggle} Add Char function later
            >
                <Group>
                    <Skeleton height={45} circle mb="xs" />
                    <Box sx={{ flex: 1 }}>
                        <Text color="white" weight={500} size="sm">
                            {chars.firstname} {chars.lastname}
                        </Text>
                        <Text color="dimmed" size="xs">
                            {chars.age} "{chars.sex}"
                        </Text>
                    </Box>
                    <FontAwesomeIcon icon={faChevronRight} style={{right: 0}}/> 
                </Group>
                
            </UnstyledButton>
        </Box>
    );
};