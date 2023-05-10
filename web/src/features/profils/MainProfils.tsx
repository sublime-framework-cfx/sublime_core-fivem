import React, { useState } from "react";
import { Text, Aside, AppShell, Navbar, Header, Footer, Skeleton } from "@mantine/core";
import { useConfig } from "../../providers/ConfigProvider";
import { useNuiEvent } from "../../hooks/useNuiEvent";
import { User, UserProps } from "./components";

const MainProfilesMenu: React.FC = () => {

    const [data, setData] = useState<UserProps>({ username: "", permission: "" });

    const [opened, setOpened] = useState(true); // on true per default during dev
    return (
        <AppShell
            styles={{
                main: {
                    display: 'flex',
                },
            }}
            navbarOffsetBreakpoint="sm"
            asideOffsetBreakpoint="sm"
            navbar={
                <Navbar p="md" hiddenBreakpoint="sm" hidden={!opened} width={{ sm: 200, lg: 300 }}>
                    <Navbar.Section grow mt="xs">
                        {/*Call Char componenets <NavChar>*/}
                        <Text>Boutton Add / Choice Char</Text>
                        <Skeleton visible={true} width="100%" height="100%"/>
                    </Navbar.Section>
                    <Navbar.Section>
                        {/*Profile Settings*/}
                        <User username={data.username || 'SUP2Ak'} permission={data.permission || 'Player'} logo={data.logo || 'https://avatars.githubusercontent.com/u/31973315?v=4'}/>
                    </Navbar.Section>
                </Navbar>
            }
            aside={
                <Aside p="md" hiddenBreakpoint="sm" width={{ sm: 200, lg: 300 }}>
                    {/*Call Char components from <NavChar> texture ...*/}
                    <Text>Char component (skin)</Text>
                    <Skeleton visible={true} width="100%" height="100%"/>
                </Aside>
            }
            footer={
                <Footer height={60} p="md">
                    {/*Footer, help, link ...*/}
                    <Text>Link (discord ...) + help</Text>
                    <Skeleton visible={true} width="100%" height="100%"/>
                </Footer>
            }
            header={
                <Header height={{ base: 50, md: 70 }} p="md">
                    {/* Welcome User ... */}
                    <Text>Welcome on sublime core {data.username ||'SUP2Ak'} ...</Text>
                    <Skeleton visible={true} width="100%" height="100%"/>
                </Header>
            }
        >
            
            {/*Main compoenent to add char 3d view + stats rect*/}
            <Skeleton visible={true} width="100%" height="100%"/>
            <Text color="black">Main View 3D char + Stats of Char + Cam button</Text>
            <Skeleton visible={true} width="100%" height="100%"/>
        </AppShell>
    );
}

export default MainProfilesMenu;