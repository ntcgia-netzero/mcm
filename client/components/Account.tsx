import { useState, useEffect } from 'react'
import { supabase } from '../lib/supabase'
import { View, Text, TextInput, TouchableOpacity, Alert, ActivityIndicator } from 'react-native'
import { Session } from '@supabase/supabase-js'

export default function Account({ session }: { session: Session }) {
    const [loading, setLoading] = useState(true)
    const [username, setUsername] = useState('')
    const [website, setWebsite] = useState('')
    const [avatarUrl, setAvatarUrl] = useState('')

    useEffect(() => {
        if (session) getProfile()
    }, [session])

    async function getProfile() {
        try {
            setLoading(true)
            if (!session?.user) throw new Error('No user on the session!')

            const { data, error, status } = await supabase
                .from('profiles')
                .select(`username, website, avatar_url`)
                .eq('id', session?.user.id)
                .single()
            if (error && status !== 406) {
                throw error
            }

            if (data) {
                setUsername(data.username)
                setWebsite(data.website)
                setAvatarUrl(data.avatar_url)
            }
        } catch (error) {
            if (error instanceof Error) {
                Alert.alert(error.message)
            }
        } finally {
            setLoading(false)
        }
    }

    async function updateProfile({
        username,
        website,
        avatar_url,
    }: {
        username: string
        website: string
        avatar_url: string
    }) {
        try {
            setLoading(true)
            if (!session?.user) throw new Error('No user on the session!')

            const updates = {
                id: session?.user.id,
                username,
                website,
                avatar_url,
                updated_at: new Date(),
            }

            const { error } = await supabase.from('profiles').upsert(updates)

            if (error) {
                throw error
            } else {
                Alert.alert('Profile updated!')
            }
        } catch (error) {
            if (error instanceof Error) {
                Alert.alert(error.message)
            }
        } finally {
            setLoading(false)
        }
    }

    return (
        <View className="flex-1 px-6 pt-10 bg-white">
            <View className="mb-6">
                <Text className="text-base mb-2 text-gray-700">Email</Text>
                <TextInput
                    className="border border-gray-300 rounded px-4 py-3 bg-gray-100 text-gray-500"
                    value={session?.user?.email || ''}
                    editable={false}
                />
            </View>

            <View className="mb-6">
                <Text className="text-base mb-2 text-gray-700">Username</Text>
                <TextInput
                    className="border border-gray-300 rounded px-4 py-3"
                    value={username || ''}
                    onChangeText={setUsername}
                />
            </View>

            <View className="mb-6">
                <Text className="text-base mb-2 text-gray-700">Website</Text>
                <TextInput
                    className="border border-gray-300 rounded px-4 py-3"
                    value={website || ''}
                    onChangeText={setWebsite}
                />
            </View>

            {loading && (
                <ActivityIndicator size="large" className="mb-4" />
            )}

            <TouchableOpacity
                className="bg-blue-600 rounded p-4 mb-4"
                onPress={() => updateProfile({ username, website, avatar_url: avatarUrl })}
                disabled={loading}
            >
                <Text className="text-white text-center font-semibold">
                    {loading ? 'Loading ...' : 'Update'}
                </Text>
            </TouchableOpacity>

            <TouchableOpacity
                className="border border-red-500 rounded p-4"
                onPress={() => supabase.auth.signOut()}
            >
                <Text className="text-red-500 text-center font-semibold">Sign Out</Text>
            </TouchableOpacity>
        </View>
    )
}
