import { Tabs } from 'expo-router';
import FontAwesome from '@expo/vector-icons/FontAwesome';
import FontAwesome5 from '@expo/vector-icons/FontAwesome5';
import Feather from '@expo/vector-icons/Feather';
import MaterialIcons from '@expo/vector-icons/MaterialIcons';
import FontAwesome6 from '@expo/vector-icons/FontAwesome6';
import Entypo from '@expo/vector-icons/Entypo';


export default function TabLayout() {
	return (
		<Tabs
			screenOptions={{
				tabBarActiveTintColor: '#2b7fff',
				headerShown: false,
				tabBarShowLabel: false,
				tabBarIconStyle: { marginVertical: 'auto' },
				tabBarStyle: {
					height: 80,
					paddingHorizontal: 10,
					borderTopLeftRadius: 20,
					borderTopRightRadius: 20,
					borderTopWidth: 0,
					backgroundColor: '#fff',
					shadowColor: '#000',
					shadowOffset: { width: 0, height: -2 },
					shadowOpacity: 0.1,
					shadowRadius: 10,
					elevation: 10, // Android shadow // TODO delete
				},
				sceneStyle: {
					backgroundColor: '#fff',
				},
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
					title: '電力管理',
					tabBarIcon: ({ color }) => <MaterialIcons name="electric-bolt" size={24} color={color} />,
				}}
			/>
		</Tabs>
	);
}