import { Tabs } from 'expo-router';
import { Palette } from '@/theme';
import { FontAwesome, FontAwesome5, FontAwesome6, Feather, MaterialIcons, MaterialCommunityIcons, Entypo } from '@expo/vector-icons';
import { View, Text } from 'react-native';
import { getHeaderTitle } from '@react-navigation/elements';
import { SafeAreaView } from 'react-native-safe-area-context';
export default function TabsLayout() {

    return (
        <Tabs
            screenOptions={{
                tabBarActiveTintColor: Palette.primary,
                tabBarLabelPosition: 'below-icon',
                tabBarIconStyle: { marginVertical: 'auto' },
                tabBarStyle: {
                    borderTopWidth: 0,
                    backgroundColor: '#fff',
                    shadowColor: '#000',
                    shadowOffset: { width: 0, height: -2 },
                    shadowOpacity: 0.1,
                    shadowRadius: 10,
                },
                sceneStyle: {
                    backgroundColor: '#fff',
                },
                headerStyle: {
                    backgroundColor: Palette.primary,
                },
                headerTitleStyle: {
                    fontSize: 20,
                    fontWeight: 'bold',
                    color: '#fff',
                },
                headerTitleAlign: 'center',
                // header: ({ navigation, route, options }) => {
                //     const title = getHeaderTitle(options, route.name);
                //     return (
                //         <SafeAreaView className='bg-blue-400'>
                //             <Text className='text-white text-2xl font-bold text-center'>{title}</Text>
                //         </SafeAreaView>
                //     );
                // } // TODO delete
            }}
        >
            <Tabs.Screen
                name="home"
                options={{
                    title: 'Home',
                    tabBarIcon: ({ color }) => <Entypo name="home" size={24} color={color} />,
                }}
            />
            <Tabs.Screen
                name="electricity"
                options={{
                    title: '電力使用管理',
                    tabBarLabel: '電力管理',
                    tabBarIcon: ({ color }) => <MaterialIcons name="electric-bolt" size={24} color={color} />,
                }}
            />
        </Tabs>
    );
}