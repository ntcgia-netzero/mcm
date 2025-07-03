import { Text, TouchableOpacity, View } from "react-native";
import { supabase } from '../../lib/supabase'


export default function SupabasePage() {
    async function insert() {
    const fakeUsers = [
        { name: 'alice' },
        { name: 'bob' },
        { name: 'charlie' },
        { name: 'david' },
        { name: 'eve' },
        { name: 'frank' },
        { name: 'grace' },
        { name: 'heidi' },
        { name: 'ivan' },
        { name: 'judy' }
    ];

    const { error } = await supabase
        .from('user')
        .insert(fakeUsers);

    console.log(error);
    }

    return (
        <View>
            <TouchableOpacity
                className="bg-blue-600 rounded p-4 mb-4"
                onPress={() => insert()}
            >
            </TouchableOpacity>
        </View>
    )
};